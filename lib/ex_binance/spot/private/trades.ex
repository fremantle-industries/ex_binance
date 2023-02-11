defmodule ExBinance.Spot.Private.Trades do
  import ExBinance.Rest.SpotClient, only: [get: 4]

  def historic_trades(symbol, from, limit \\ 1000, credentials) do
    with {:ok, data} <-
           get(
             "/api/v3/historicalTrades",
             %{symbol: symbol, limit: limit, fromId: from},
             credentials,
             signed: false
           ) do
      {:ok, Enum.map(data, &ExBinance.Trade.new/1)}
    end
  end
end
