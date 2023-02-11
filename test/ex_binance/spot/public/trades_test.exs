defmodule ExBinance.Spot.Private.TradesTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExBinance.Spot.Public.Trades

  setup_all do
    HTTPoison.start()
  end

  describe "recent_trades" do
    test "can query recent trades" do
      use_cassette "spot/private/recent_trades" do
        assert {:ok, trades} = Trades.recent_trades("ETHBTC", 10)

        assert Enum.count(trades) == 10

        [
          %ExBinance.Trade{
            id: 401_634_051,
            is_best_match: true,
            is_buyer_maker: false,
            price: "0.07011600",
            qty: "0.30930000",
            quote_qty: "0.02168687",
            time: 1_676_129_860_788
          }
          | _
        ] = trades
      end
    end
  end
end
