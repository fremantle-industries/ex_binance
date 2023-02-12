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
            id: id,
            is_best_match: best_match,
            is_buyer_maker: is_buyer,
            price: price,
            qty: qty,
            quote_qty: quote_qty,
            time: time
          }
          | _
        ] = trades

        assert is_integer(id)
        assert is_boolean(best_match)
        assert is_boolean(is_buyer)
        assert is_binary(price)
        assert is_binary(qty)
        assert is_binary(quote_qty)
        assert is_integer(time)
      end
    end
  end
end
