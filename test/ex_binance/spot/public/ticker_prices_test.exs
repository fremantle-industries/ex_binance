defmodule ExBinance.Spot.Public.TickerPricesTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.Spot.Public

  setup_all do
    HTTPoison.start()
  end

  test ".ticker_prices returns a list of prices for every symbol" do
    use_cassette "spot/public/ticker_prices_ok" do
      assert {:ok, symbol_prices} = Public.ticker_prices()

      assert Enum.find(symbol_prices, fn x -> x.symbol == "ETHBTC" end) != nil

      assert symbol_prices |> Enum.count() > 0
    end
  end
end
