defmodule ExBinance.Rest.Responses.CancelOrderResponse do
  @type t :: %__MODULE__{}

  defstruct ~w(
    client_order_id
    cummulative_quote_qty
    executed_qty
    order_id
    orig_client_order_id
    orig_qty
    price
    side
    status
    symbol
    time_in_force
    type
  )a

  use ExConstructor
end
