defmodule ExBinance.Spot.Private do
  alias __MODULE__

  defdelegate account(credentials), to: Private.Account

  defdelegate create_order(
                symbol,
                side,
                type,
                quantity,
                price,
                time_in_force,
                credentials
              ),
              to: Private.CreateOrder

  defdelegate create_order(params, credentials), to: Private.CreateOrder

  defdelegate cancel_order_by_order_id(
                symbol,
                order_id,
                credentials
              ),
              to: Private.CancelOrder

  defdelegate cancel_order_by_client_order_id(
                symbol,
                client_order_id,
                credentials
              ),
              to: Private.CancelOrder

  defdelegate cancel_all_orders(symbol, credentials), to: Private.CancelAllOrders

  defdelegate query_order_by_order_id(symbol, order_id, credentials),
    to: Private.QueryOrder

  defdelegate query_order_by_client_order_id(symbol, client_order_id, credentials),
    to: Private.QueryOrder
end
