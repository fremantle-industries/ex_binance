defmodule ExBinance.Spot.Private.TradesTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExBinance.Spot.Private.Trades

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  describe "historic_trades" do
    test "can query historic trades" do
      use_cassette "spot/private/historic_trades" do
        assert {:ok, trades} = Trades.historic_trades("ETHBTC", 0, 10, @credentials)

        assert Enum.count(trades) == 10

        [
          %ExBinance.Trade{
            id: 10,
            is_best_match: true,
            is_buyer_maker: true,
            price: "0.08000000",
            qty: "0.30800000",
            quote_qty: "0.02464000",
            time: 1_500_005_216_092
          }
          | _
        ] = trades
      end
    end
  end
end
