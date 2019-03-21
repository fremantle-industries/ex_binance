defmodule ExBinanceTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBinance

  setup_all do
    HTTPoison.start()
  end

  test "ping returns an empty map" do
    use_cassette "ping_ok" do
      assert ExBinance.ping() == {:ok, %{}}
    end
  end

  test "get_server_time success return an ok, time tuple" do
    use_cassette "get_server_time_ok" do
      assert ExBinance.get_server_time() == {:ok, 1_521_781_361_467}
    end
  end

  test "get_exchange_info success returns the trading rules and symbol information" do
    use_cassette "get_exchange_info_ok" do
      assert {:ok, %ExBinance.ExchangeInfo{} = info} = ExBinance.get_exchange_info()
      assert info.timezone == "UTC"
      assert info.server_time != nil

      assert info.rate_limits == [
               %{"interval" => "MINUTE", "limit" => 1200, "rateLimitType" => "REQUESTS"},
               %{"interval" => "SECOND", "limit" => 10, "rateLimitType" => "ORDERS"},
               %{"interval" => "DAY", "limit" => 100_000, "rateLimitType" => "ORDERS"}
             ]

      assert info.exchange_filters == []
      assert [symbol | _] = info.symbols

      assert symbol == %{
               "baseAsset" => "ETH",
               "baseAssetPrecision" => 8,
               "filters" => [
                 %{
                   "filterType" => "PRICE_FILTER",
                   "maxPrice" => "100000.00000000",
                   "minPrice" => "0.00000100",
                   "tickSize" => "0.00000100"
                 },
                 %{
                   "filterType" => "LOT_SIZE",
                   "maxQty" => "100000.00000000",
                   "minQty" => "0.00100000",
                   "stepSize" => "0.00100000"
                 },
                 %{"filterType" => "MIN_NOTIONAL", "minNotional" => "0.00100000"}
               ],
               "icebergAllowed" => false,
               "orderTypes" => [
                 "LIMIT",
                 "LIMIT_MAKER",
                 "MARKET",
                 "STOP_LOSS_LIMIT",
                 "TAKE_PROFIT_LIMIT"
               ],
               "quoteAsset" => "BTC",
               "quotePrecision" => 8,
               "status" => "TRADING",
               "symbol" => "ETHBTC"
             }
    end
  end

  test "get_all_prices returns a list of prices for every symbol" do
    use_cassette "get_all_prices_ok" do
      assert {:ok, symbol_prices} = ExBinance.get_all_prices()

      assert [%ExBinance.SymbolPrice{price: "0.06137000", symbol: "ETHBTC"} | _tail] =
               symbol_prices

      assert symbol_prices |> Enum.count() == 288
    end
  end

  describe ".get_depth" do
    test "returns the bids & asks up to the given depth" do
      use_cassette "get_depth_ok" do
        assert ExBinance.get_depth("BTCUSDT", 5) == {
                 :ok,
                 %ExBinance.OrderBook{
                   asks: [
                     ["8400.00000000", "2.04078100", []],
                     ["8405.35000000", "0.50354700", []],
                     ["8406.00000000", "0.32769800", []],
                     ["8406.33000000", "0.00239000", []],
                     ["8406.51000000", "0.03241000", []]
                   ],
                   bids: [
                     ["8393.00000000", "0.20453200", []],
                     ["8392.57000000", "0.02639000", []],
                     ["8392.00000000", "1.40893300", []],
                     ["8390.09000000", "0.07047100", []],
                     ["8388.72000000", "0.04577400", []]
                   ],
                   last_update_id: 113_634_395
                 }
               }
      end
    end

    test "returns an error tuple when the symbol doesn't exist" do
      use_cassette "get_depth_error" do
        assert ExBinance.get_depth("IDONTEXIST", 1000) == {:error, :bad_symbol}
      end
    end
  end
end
