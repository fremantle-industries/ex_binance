defmodule ExBinance.Public do
  import ExBinance.Rest.HTTPClient, only: [get: 2]

  def ping, do: get("/api/v1/ping", %{})

  def server_time do
    with {:ok, %{"serverTime" => time}} <- get("/api/v1/time", %{}) do
      {:ok, time}
    end
  end

  def exchange_info do
    with {:ok, data} <- get("/api/v1/exchangeInfo", %{}) do
      {:ok, ExBinance.ExchangeInfo.new(data)}
    end
  end

  def all_prices do
    with {:ok, data} <- get("/api/v1/ticker/allPrices", %{}) do
      {:ok, Enum.map(data, &ExBinance.SymbolPrice.new(&1))}
    end
  end

  def depth(symbol, limit) do
    with {:ok, data} <- get("/api/v1/depth", %{symbol: symbol, limit: limit}) do
      {:ok, ExBinance.OrderBook.new(data)}
    end
  end
end
