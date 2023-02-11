defmodule ExBinance.Spot.Public.Trades do
  import ExBinance.Rest.SpotClient, only: [get: 2, get: 4]

  def recent_trades(symbol, limit \\ 1000) do
    with {:ok, data} <- get("/api/v3/trades", %{symbol: symbol, limit: limit}) do
      {:ok, Enum.map(data, &ExBinance.Trade.new/1)}
    end
  end

  def historic_trades(symbol, from, limit \\ 1000) do
    credentials = ExBinance.Credentials.from_config()

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
