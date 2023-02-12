defmodule ExBinance.Spot.Public.TradesTest do
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
