defmodule ExBinance.CreateOrderResponse do
  defstruct ~w(
    client_order_id
    executed_qty
    order_id
    orig_qty
    price
    side
    status
    symbol
    time_in_force
    transact_time
    type
    fills
  )a

  use ExConstructor
end
