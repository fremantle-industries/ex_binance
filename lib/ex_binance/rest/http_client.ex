defmodule ExBinance.Rest.HTTPClient do
  @type header :: {key :: String.t(), value :: String.t()}
  @type config_error :: {:config_missing, String.t()}
  @type timeout_error :: :timeout
  @type connect_timeout_error :: :connect_timeout
  @type http_error :: {:http_error, any}
  @type decode_error :: {:decode_error, Jason.DecodeError.t()}
  @type bad_symbol_error :: :bad_symbol
  @type unhandled_binance_error :: {:binance_error, map}
  @type shared_errors ::
          timeout_error
          | connect_timeout_error
          | http_error
          | decode_error
          | bad_symbol_error
          | unhandled_binance_error

  @endpoint "https://api.binance.com"
  @receive_window 5000
  @api_key_header "X-MBX-APIKEY"

  @spec get_binance(String.t(), [header]) :: {:ok, any} | {:error, config_error | shared_errors}
  def get_binance(url, headers \\ []) do
    "#{@endpoint}#{url}"
    |> HTTPoison.get(headers)
    |> parse_response
  end

  def get_binance(_url, _params, nil, nil),
    do: {:error, {:config_missing, "Secret and API key missing"}}

  def get_binance(_url, _params, nil, _api_key),
    do: {:error, {:config_missing, "Secret key missing"}}

  def get_binance(_url, _params, _secret_key, nil),
    do: {:error, {:config_missing, "API key missing"}}

  def get_binance(url, params, secret_key, api_key) do
    headers = [{@api_key_header, api_key}]
    ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    params =
      Map.merge(params, %{
        timestamp: ts,
        recvWindow: @receive_window
      })

    argument_string = URI.encode_query(params)
    signature = sign(secret_key, argument_string)

    get_binance("#{url}?#{argument_string}&signature=#{signature}", headers)
  end

  @spec post_binance(String.t(), map) :: {:ok, any} | {:error, shared_errors}
  def post_binance(url, params) do
    argument_string =
      params
      |> Map.to_list()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
      |> Enum.join("&")

    api_key = Application.get_env(:ex_binance, :api_key)
    secret_key = Application.get_env(:ex_binance, :secret_key)
    signature = sign(secret_key, argument_string)
    body = "#{argument_string}&signature=#{signature}"
    headers = [{@api_key_header, api_key}]

    "#{@endpoint}#{url}"
    |> HTTPoison.post(body, headers)
    |> parse_response()
  end

  defp sign(secret_key, argument_string),
    do: :sha256 |> :crypto.hmac(secret_key, argument_string) |> Base.encode16()

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
  defp parse_response_body({:ok, %{"code" => _} = reason}), do: {:error, {:binance_error, reason}}
  defp parse_response_body({:ok, _} = result), do: result
  defp parse_response_body({:error, err}), do: {:error, {:decode_error, err}}
end
