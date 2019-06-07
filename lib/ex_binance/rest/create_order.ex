defmodule ExBinance.Rest.CreateOrder do
  alias ExBinance.Rest.HTTPClient

  @path "/api/v3/order"
  @receiving_window 1000

  def create_order(symbol, side, type, quantity, price, time_in_force, credentials) do
    params = %{
      symbol: symbol,
      side: side,
      type: type,
      quantity: quantity,
      price: price,
      timeInForce: time_in_force,
      timestamp: :os.system_time(:millisecond),
      recvWindow: @receiving_window
    }

    @path
    |> HTTPClient.post(params, credentials)
    |> parse_response()
  end

  defp parse_response({:ok, response}), do: {:ok, ExBinance.CreateOrderResponse.new(response)}

  defp parse_response({:error, {:binance_error, %{"code" => -2010, "msg" => msg}}}),
    do: {:error, {:insufficient_balance, msg}}

  defp parse_response({:error, _} = error), do: error
end
