defmodule ExBinance.Spot.Private.Requests.CreateOrderRequest do
  @type t :: %__MODULE__{}

  defstruct ~w[
    new_client_order_id
    symbol
    side
    type
    quantity
    quote_order_qty
    price
    stop_price
    time_in_force
    timestamp
    recv_window
  ]a
end
