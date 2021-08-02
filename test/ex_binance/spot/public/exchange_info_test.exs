defmodule ExBinance.Spot.Public.ExchangeInfoTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.Spot.Public

  setup_all do
    HTTPoison.start()
  end

  test ".exchange_info success returns the trading rules and symbol information" do
    use_cassette "spot/public/exchange_info_ok" do
      assert {:ok, %ExBinance.ExchangeInfo{} = info} = Public.exchange_info()
      assert info.timezone == "UTC"
      assert info.server_time != nil

      assert info.rate_limits == [
               %{
                 "interval" => "MINUTE",
                 "limit" => 1200,
                 "rateLimitType" => "REQUEST_WEIGHT",
                 "intervalNum" => 1
               },
               %{
                 "interval" => "SECOND",
                 "limit" => 50,
                 "rateLimitType" => "ORDERS",
                 "intervalNum" => 10
               },
               %{
                 "interval" => "DAY",
                 "limit" => 160_000,
                 "rateLimitType" => "ORDERS",
                 "intervalNum" => 1
               }
             ]

      assert info.exchange_filters == []
      assert [symbol | _] = info.symbols

      assert symbol == %{
               "baseAsset" => "BNB",
               "baseAssetPrecision" => 8,
               "filters" => [
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
end
