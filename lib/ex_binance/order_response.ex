defmodule ExBinance.OrderResponse do
  defstruct [
    :client_order_id,
    :executed_qty,
    :order_id,
    :orig_qty,
    :price,
    :side,
    :status,
    :symbol,
    :time_in_force,
    :transact_time,
    :type,
    :fills
  ]

  use ExConstructor
end
