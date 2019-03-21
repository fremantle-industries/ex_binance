defmodule ExBinance.Rest.Orders do
  alias ExBinance.Rest.HTTPClient

  @path "/api/v3/order"

  def create_order(
        symbol,
        side,
        type,
        quantity,
        price,
        time_in_force,
        new_client_order_id \\ nil,
        stop_price \\ nil,
        iceberg_quantity \\ nil,
        receiving_window \\ 1000,
        timestamp \\ :os.system_time(:millisecond)
      ) do
    arguments =
      %{
        symbol: symbol,
        side: side,
        type: type,
        quantity: quantity,
        timestamp: timestamp,
        recvWindow: receiving_window
      }
      |> Map.merge(
        unless(
          is_nil(new_client_order_id),
          do: %{newClientOrderId: new_client_order_id},
          else: %{}
        )
      )
      |> Map.merge(unless(is_nil(stop_price), do: %{stopPrice: stop_price}, else: %{}))
      |> Map.merge(
        unless(is_nil(new_client_order_id), do: %{icebergQty: iceberg_quantity}, else: %{})
      )
      |> Map.merge(unless(is_nil(time_in_force), do: %{timeInForce: time_in_force}, else: %{}))
      |> Map.merge(unless(is_nil(price), do: %{price: price}, else: %{}))

    @path
    |> HTTPClient.post_binance(arguments)
    |> parse_response()
  end

  defp parse_response({:ok, response}) do
    {:ok, ExBinance.OrderResponse.new(response)}
  end

  defp parse_response({:error, {:binance_error, %{"code" => -2010, "msg" => msg}}}) do
    {:error, {:insufficient_balance, msg}}
  end

  defp parse_response({:error, _} = error), do: error
end
