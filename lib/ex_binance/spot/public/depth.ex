defmodule ExBinance.Spot.Public.Depth do
  import ExBinance.Rest.SpotClient, only: [get: 2]

  def depth(symbol, limit) do
    with {:ok, data} <- get("/api/v3/depth", %{symbol: symbol, limit: limit}) do
      {:ok, ExBinance.OrderBook.new(data)}
    end
  end
end
