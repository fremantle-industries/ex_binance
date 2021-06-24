defmodule ExBinance.Kline do
  @moduledoc """
  Struct for representing the result returned by /api/v3/klines
  """

  defstruct [
    :open_time,
    :open,
    :high,
    :low,
    :close,
    :volume,
    :close_time,
    :quote_asset_volume,
    :number_of_trades,
    :taker_buy_base_asset_volume,
    :taker_buy_quote_asset_volume
  ]

  use ExConstructor
end
