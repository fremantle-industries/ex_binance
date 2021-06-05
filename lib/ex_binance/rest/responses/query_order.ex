defmodule ExBinance.Rest.Responses.QueryOrderResponse do
  @type t :: %__MODULE__{}

  defstruct ~w(
    symbol
    order_id
    order_list_id
    client_order_id
    price
    orig_qty
    executed_qty
    cummulative_quote_qty
    status
    time_in_force
    type
    side
    stop_price
    iceberg_qty
    time
    update_time
    is_working
    orig_quote_order_qty
  )a

  use ExConstructor
end
