defmodule ExBinance.Trade do
  @moduledoc """
  Struct for representing a result row as returned by /api/v3/trades and /api/v3/historicalTrades
  """

  defstruct [:id, :is_best_match, :is_buyer_maker, :price, :qty, :quote_qty, :time]
  use ExConstructor
end
