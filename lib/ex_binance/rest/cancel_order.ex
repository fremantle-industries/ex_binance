defmodule ExBinance.Rest.CancelOrder do
  alias ExBinance.Rest.HTTPClient
  alias ExBinance.Timestamp

  @type symbol :: String.t()
  @type order_id :: String.t()
  @type credentials :: ExBinance.Credentials.t()
  @type ok_response :: ExBinance.Responses.CancelOrder.t()

  @path "/api/v3/order"
  @receiving_window 1000

  @spec cancel_order_by_order_id(symbol, order_id, credentials) ::
          {:ok, ok_response} | {:error, {:not_found, String.t()}}
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

  defp parse_response({:ok, response}), do: {:ok, ExBinance.Responses.CancelOrder.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2011, "msg" => msg}}}),
    do: {:error, {:not_found, msg}}
end
