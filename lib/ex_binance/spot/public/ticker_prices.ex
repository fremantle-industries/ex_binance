defmodule ExBinance.Spot.Public.TickerPrices do
  import ExBinance.Rest.SpotClient, only: [get: 2]

  def ticker_prices do
    with {:ok, data} <- get("/api/v3/ticker/price", %{}) do
      {:ok, Enum.map(data, &ExBinance.SymbolPrice.new(&1))}
    end
  end
end
