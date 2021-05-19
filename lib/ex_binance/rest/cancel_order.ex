defmodule ExBinance.Rest.CancelOrder do
  alias ExBinance.Rest.{HTTPClient, Responses}
  alias ExBinance.Timestamp

  @type symbol :: String.t()
  @type order_id :: String.t()
  @type credentials :: ExBinance.Credentials.t()
  @type response :: Responses.CancelOrderResponse.t()
  @type error_msg :: String.t()
  @type error_reason :: {:not_found, error_msg} | HTTPClient.shared_errors()

  @path "/api/v3/order"
  @receiving_window 1000

  @spec cancel_order_by_order_id(symbol, order_id, credentials) ::
          {:ok, response} | {:error, error_reason}
  def cancel_order_by_order_id(symbol, order_id, credentials) do
    params = %{
      symbol: symbol,
      orderId: order_id,
      timestamp: Timestamp.now(),
      recvWindow: @receiving_window
    }

    @path
    |> HTTPClient.delete(params, credentials)
    |> parse_response()
  end

  defp parse_response({:ok, response}), do: {:ok, Responses.CancelOrderResponse.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2011, "msg" => msg}}}) do
    {:error, {:not_found, msg}}
  end

  defp parse_response({:error, _} = error), do: error
end
