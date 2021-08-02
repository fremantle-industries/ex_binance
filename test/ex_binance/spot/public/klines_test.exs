defmodule ExBinance.Spot.Public.KlinesTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.Spot.Public

  setup_all do
    HTTPoison.start()
  end

  describe ".klines" do
    test "returns klines for a given symbol and interval" do
      use_cassette "spot/public/klines_symbol_interval_ok" do
        {:ok, klines} = Public.klines("BTCUSDT", "1m")

        assert [
                 %ExBinance.Kline{
                   close: "33336.52000000",
                   close_time: 1_624_529_639_999,
                   high: "33336.52000000",
                   low: "33325.49000000",
                   number_of_trades: 28,
                   open: "33334.78000000",
                   open_time: 1_624_529_580_000,
                   quote_asset_volume: "10243.20474104",
                   taker_buy_base_asset_volume: "0.24031200",
                   taker_buy_quote_asset_volume: "8009.99722824",
                   volume: "0.30731600"
                 }
                 | _tail
               ] = klines

        assert length(klines) == 500
      end
    end

    test "returns klines for a given symbol, interval and limit" do
      use_cassette "spot/public/klines_symbol_interval_limit_ok" do
        {:ok, klines} = Public.klines("BTCUSDT", "1m", 1, nil, nil)

        assert [
                 %ExBinance.Kline{
                   close: "35047.03000000",
                   close_time: 1_624_559_579_999,
                   high: "35047.03000000",
                   low: "34800.01000000",
                   number_of_trades: 37,
                   open: "34970.90000000",
                   open_time: 1_624_559_520_000,
                   quote_asset_volume: "14686.87819470",
                   taker_buy_base_asset_volume: "0.41391700",
                   taker_buy_quote_asset_volume: "14492.85555020",
                   volume: "0.41947200"
                 }
               ] = klines
      end
    end

    test "returns klines for a given symbol, interval, start time, end time and limit" do
      use_cassette "spot/public/klines_symbol_interval_with_time_and_limit_ok" do
        assert {:ok, klines} =
                 Public.klines("BTCUSDT", "1m", 2, 1_624_438_800_000, 1_624_440_000_000)

        assert [kline_1, kline_2] = klines

        assert kline_1 == %ExBinance.Kline{
                 close: "33784.38000000",
                 close_time: 1_624_438_859_999,
                 high: "33800.00000000",
                 low: "33666.01000000",
                 number_of_trades: 52,
                 open: "33800.00000000",
                 open_time: 1_624_438_800_000,
                 quote_asset_volume: "21900.06475101",
                 taker_buy_base_asset_volume: "0.45358400",
                 taker_buy_quote_asset_volume: "15296.35728097",
                 volume: "0.64906000"
               }

        assert kline_2 ==
                 %ExBinance.Kline{
                   close: "33845.40000000",
                   close_time: 1_624_438_919_999,
                   high: "33845.40000000",
                   low: "33785.58000000",
                   number_of_trades: 35,
                   open: "33789.26000000",
                   open_time: 1_624_438_860_000,
                   quote_asset_volume: "16527.62739828",
                   taker_buy_base_asset_volume: "0.48791700",
                   taker_buy_quote_asset_volume: "16498.06501578",
                   volume: "0.48879200"
                 }
      end
    end
  end
end
