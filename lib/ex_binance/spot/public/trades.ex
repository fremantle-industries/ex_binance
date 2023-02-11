defmodule ExBinance.Spot.Public.Trades do
  import ExBinance.Rest.SpotClient, only: [get: 2]

  def recent_trades(symbol, limit \\ 1000) do
    with {:ok, data} <- get("/api/v3/trades", %{symbol: symbol, limit: limit}) do
      {:ok, Enum.map(data, &ExBinance.Trade.new/1)}
    end
  end
end
