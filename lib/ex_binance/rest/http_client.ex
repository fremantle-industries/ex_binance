defmodule ExBinance.Rest.HTTPClient do
  @type credentials :: ExBinance.Credentials.t()
  @type path :: String.t()
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

  @spec get(path, map, [header]) :: {:ok, any} | {:error, shared_errors}
  def get(path, params, headers \\ []) do
    query = URI.encode_query(params)
    uri = %URI{path: path, query: query} |> URI.to_string()

    [@endpoint, uri]
    |> Path.join()
    |> HTTPoison.get(headers)
    |> parse_response
  end

  @spec get_auth(path, map, credentials) :: {:ok, any} | {:error, shared_errors}
  def get_auth(path, params, credentials) do
    params =
      params
      |> Map.merge(%{
        timestamp: DateTime.utc_now() |> DateTime.to_unix(:millisecond),
        recvWindow: @receive_window
      })

    query = URI.encode_query(params)
    signature = sign(credentials.secret_key, query)
    signed_params = params |> Map.put(:signature, signature)
    headers = [{@api_key_header, credentials.api_key}]

    get(path, signed_params, headers)
  end

  @spec post(String.t(), map, credentials) :: {:ok, any} | {:error, shared_errors}
  def post(path, params, credentials) do
    argument_string =
      params
      |> Map.to_list()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
      |> Enum.join("&")

    signature = sign(credentials.secret_key, argument_string)
    body = "#{argument_string}&signature=#{signature}"
    headers = [{@api_key_header, credentials.api_key}]

    "#{@endpoint}#{path}"
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
