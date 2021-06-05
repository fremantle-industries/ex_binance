defmodule ExBinance.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  test ".ping returns an empty map" do
    use_cassette "ping_ok" do
      assert ExBinance.Public.ping() == {:ok, %{}}
    end
  end

  test ".server_time success return an ok, time tuple" do
    use_cassette "get_server_time_ok" do
      {:ok, server_time} = ExBinance.Public.server_time()
      assert server_time > 1_521_781_361_467
    end
  end

  test ".exchange_info success returns the trading rules and symbol information" do
    use_cassette "get_exchange_info_ok" do
      assert {:ok, %ExBinance.ExchangeInfo{} = info} = ExBinance.Public.exchange_info()
      assert info.timezone == "UTC"
      assert info.server_time != nil

      assert info.rate_limits == [
               %{"interval" => "MINUTE", "limit" => 1200, "rateLimitType" => "REQUEST_WEIGHT", "intervalNum" => 1},
               %{"interval" => "DAY", "limit" => 160_000, "rateLimitType" => "ORDERS", "intervalNum" => 1}
             ]

      assert info.exchange_filters == []
      assert [symbol | _] = info.symbols

      assert symbol == %{
               "baseAsset" => "BNB",
               "baseAssetPrecision" => 8,
               "filters" =>  [
                %{
                  "filterType" => "PRICE_FILTER",
                  "maxPrice" => "10000.00000000",
                  "minPrice" => "0.01000000",
                  "tickSize" => "0.01000000"
                },
                %{
                  "filterType" => "PERCENT_PRICE",
                  "avgPriceMins" => 5,
                  "multiplierDown" => "0.2",
                  "multiplierUp" => "5"
                },
                %{
                  "filterType" => "LOT_SIZE",
                  "maxQty" => "9000.00000000",
                  "minQty" => "0.01000000",
                  "stepSize" => "0.01000000"
                },
                %{
                  "applyToMarket" => true,
                  "avgPriceMins" => 5,
                  "filterType" => "MIN_NOTIONAL",
                  "minNotional" => "10.00000000"
                },
                %{
                  "filterType" => "ICEBERG_PARTS",
                  "limit" => 10
                },
                %{
                  "filterType" => "MARKET_LOT_SIZE",
                  "maxQty" => "1000.00000000",
                  "minQty" => "0.00000000",
                  "stepSize" => "0.00000000"
                },
                %{
                  "filterType" => "MAX_NUM_ORDERS",
                  "maxNumOrders" => 200
                },
                %{
                  "filterType" => "MAX_NUM_ALGO_ORDERS",
                  "maxNumAlgoOrders" => 5
                }
              ],
               "icebergAllowed" => true,
               "orderTypes" => [
                 "LIMIT",
                 "LIMIT_MAKER",
                 "MARKET",
                 "STOP_LOSS_LIMIT",
                 "TAKE_PROFIT_LIMIT"
               ],
               "quoteAsset" => "BUSD",
               "quotePrecision" => 8,
               "status" => "TRADING",
               "symbol" => "BNBBUSD",
               "baseCommissionPrecision" => 8,
                "isMarginTradingAllowed" => false,
                "isSpotTradingAllowed" => true,
                "ocoAllowed" => true,
                "permissions" => ["SPOT"],
                "quoteAssetPrecision" => 8,
                "quoteCommissionPrecision" => 8,
                "quoteOrderQtyMarketAllowed" => true
             }
    end
  end

  test ".all_prices returns a list of prices for every symbol" do
    use_cassette "get_all_prices_ok" do
      assert {:ok, symbol_prices} = ExBinance.Public.all_prices()

      assert Enum.find(symbol_prices, fn x -> x.symbol == "ETHBTC" end) != nil

      assert symbol_prices |> Enum.count() > 0
    end
  end

  describe ".get_depth" do
    test "returns the bids & asks up to the given depth" do
      use_cassette "get_depth_ok" do
        assert ExBinance.Public.depth("BTCUSDT", 5) == {
                 :ok,
                 %ExBinance.OrderBook{
                   asks: [
                     ["36207.00000000", "0.00122500"],
                     ["36243.41000000", "0.02166500"],
                     ["36279.00000000", "0.00066600"],
                     ["36300.00000000", "0.00055100"],
                     ["36351.81000000", "0.00110700"]
                   ],
                   bids: [
                     ["36125.92000000", "0.01384100"],
                     ["36100.00000000", "0.00055300"],
                     ["36000.00000000", "0.00055500"],
                     ["35918.85000000", "0.00297200"],
                     ["35900.00000000", "0.00055600"]
                   ],
                   last_update_id: 929038
                 }
               }
      end
    end

    test "returns an error tuple when the symbol doesn't exist" do
      use_cassette "get_depth_error" do
        assert ExBinance.Public.depth("IDONTEXIST", 1000) == {:error, :bad_symbol}
      end
    end
  end
end
