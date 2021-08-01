defmodule ExBinance.Spot.Private.Responses.CreateOrderResponse do
  @type t :: %__MODULE__{}

  defstruct ~w[
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
  ]a

  use ExConstructor
end
