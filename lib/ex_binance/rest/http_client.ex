defmodule ExBinance.Rest.HTTPClient do
  alias ExBinance.{Auth, Credentials}

  @type credentials :: Credentials.t()
  @type endpoint :: String.t()
  @type path :: String.t()
  @type header :: {key :: String.t(), value :: String.t()}
  @type config_error :: {:config_missing, String.t()}
  @type shared_errors ::
          :timeout
          | :connect_timeout
          | {:http_error, any}
          | {:decode_error, Jason.DecodeError.t()}
          | :bad_symbol
          | :receive_window
          | {:binance_error, map}

  @receive_window 5000
  @api_key_header "X-MBX-APIKEY"

  @spec get(endpoint, path, map, [header] | credentials, keyword) ::
          {:ok, any} | {:error, shared_errors}
  def get(endpoint, path, params, headers \\ [], opts \\ [])

  def get(endpoint, path, params, headers, _opts) when is_map(params) and is_list(headers) do
    query = URI.encode_query(params)
    uri = %URI{path: path, query: query} |> URI.to_string()

    [endpoint, uri]
    |> Path.join()
    |> HTTPoison.get(headers)
    |> parse_response
  end

  def get(endpoint, path, params, %Credentials{} = credentials, opts) when is_map(params) do
    :get
    |> request(endpoint, path, params, credentials, opts)
    |> parse_response()
  end

  @spec post(endpoint, path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def post(endpoint, path, params, %Credentials{} = credentials, opts \\ [])
      when is_map(params) do
    :post
    |> request(endpoint, path, params, credentials, opts)
    |> parse_response()
  end

  @spec delete(endpoint, path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def delete(endpoint, path, params, %Credentials{} = credentials, opts \\ [])
      when is_map(params) do
    :delete
    |> request(endpoint, path, params, credentials, opts)
    |> parse_response()
  end

  @spec put(endpoint, path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def put(endpoint, path, params, %Credentials{} = credentials, opts \\ []) when is_map(params) do
    :put
    |> request(endpoint, path, params, credentials, opts)
    |> parse_response()
  end

  defp request(:get, endpoint, path, params, credentials, opts) do
    signed = Keyword.get(opts, :signed, true)
    params = maybe_sign_params(params, credentials.secret_key, signed)

    headers = [{@api_key_header, credentials.api_key}]

    HTTPoison.get("#{endpoint}#{path}", headers, params: params)
  end

  defp request(method, endpoint, path, params, credentials, opts) do
    signed = Keyword.get(opts, :signed, true)
    params = maybe_sign_params(params, credentials.secret_key, signed)

    body = URI.encode_query(params)
    headers = [{@api_key_header, credentials.api_key}]

    HTTPoison.request(method, "#{endpoint}#{path}", body, headers)
  end

  defp maybe_sign_params(params, _secret_key, false), do: params

  defp maybe_sign_params(params, secret_key, true) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    params =
      params
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Map.put(:timestamp, timestamp)
      |> maybe_add_new_client_order_id()
      |> maybe_add_time_in_force()
      |> maybe_add_recv_window()

    query_string = URI.encode_query(params)
    signature = Auth.sign(secret_key, query_string)

    Map.put(params, :signature, signature)
  end

  defp maybe_add_time_in_force(%{:time_in_force => time_in_force} = params) do
    Map.delete(params, :time_in_force)
    |> Map.put(:timeInForce, time_in_force)
  end

  defp maybe_add_time_in_force(params), do: params

  defp maybe_add_recv_window(%{:recv_window => recv_window} = params) do
    Map.delete(params, :recv_window)
    |> Map.put(:recvWindow, recv_window)
  end

  defp maybe_add_recv_window(params), do: Map.put_new(params, :recvWindow, @receive_window)

  defp maybe_add_new_client_order_id(%{:new_client_order_id => new_client_order_id} = params) do
    Map.delete(params, :new_client_order_id)
    |> Map.put(:newClientOrderId, new_client_order_id)
  end

  defp maybe_add_new_client_order_id(params), do: params

  defp parse_response({:ok, response}) do
    response.body
    |> Jason.decode()
    |> parse_response_body
  end

  defp parse_response({:error, %HTTPoison.Error{id: nil, reason: :timeout}}),
    do: {:error, :timeout}

  defp parse_response({:error, %HTTPoison.Error{id: nil, reason: :connect_timeout}}),
    do: {:error, :connect_timeout}

  defp parse_response({:error, err}), do: {:error, {:http_error, err}}

  defp parse_response_body({:ok, %{"code" => -1121}}), do: {:error, :bad_symbol}
  defp parse_response_body({:ok, %{"code" => -1021}}), do: {:error, :receive_window}
  defp parse_response_body({:ok, %{"code" => _} = reason}), do: {:error, {:binance_error, reason}}
  defp parse_response_body({:ok, _} = result), do: result
  defp parse_response_body({:error, err}), do: {:error, {:decode_error, err}}

  def spot_endpoint, do: "https://#{spot_domain()}"

  def usd_margin_futures_endpoint, do: "https://#{usd_margin_futures_domain()}"

  def coin_margin_futures_endpoint, do: "https://#{coin_margin_futures_domain()}"

  def spot_domain do
    Application.get_env(:ex_binance, :spot_domain, "api.binance.com")
  end

  def usd_margin_futures_domain do
    Application.get_env(:ex_binance, :usd_margin_futures_domain, "fapi.binance.com")
  end

  def coin_margin_futures_domain do
    Application.get_env(:ex_binance, :coin_margin_futures_domain, "dapi.binance.com")
  end
end
