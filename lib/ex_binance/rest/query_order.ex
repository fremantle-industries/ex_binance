defmodule ExBinance.Rest.QueryOrder do
  alias ExBinance.Rest.{HTTPClient, Responses}
  alias ExBinance.{Timestamp, Credentials}

  @type symbol :: String.t()
  @type order_id :: String.t()
  @type credentials :: Credentials.t()
  @type response :: Responses.QueryOrderResponse.t()
  @type error_msg :: String.t()
  @type error_reason :: {:not_found, error_msg} | HTTPClient.shared_errors()

  @path "/api/v3/order"
  @receiving_window 1000

  @spec query_order(symbol, order_id, credentials) ::
          {:ok, response} | {:error, error_reason}
  def query_order(symbol, order_id, credentials) do
    params = %{
      symbol: symbol,
      orderId: order_id,
      timestamp: Timestamp.now(),
      recvWindow: @receiving_window
    }

    @path
    |> HTTPClient.post(params, credentials)
    |> parse_response()
  end

  defp parse_response({:ok, response}), do: {:ok, Responses.QueryOrderResponse.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2013, "msg" => msg}}}) do
    {:error, {:not_found, msg}}
  end

  defp parse_response({:error, _} = error), do: error
end
