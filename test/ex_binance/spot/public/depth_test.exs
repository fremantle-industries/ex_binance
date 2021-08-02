defmodule ExBinance.Spot.Public.DepthTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.Spot.Public

  setup_all do
    HTTPoison.start()
  end

  describe ".depth" do
    test "returns the bids & asks up to the given depth" do
      use_cassette "spot/public/depth_ok" do
        assert {:ok, order_book} = Public.depth("BTCUSDT", 5)

        assert %ExBinance.OrderBook{} = order_book
        assert Enum.any?(order_book.asks)
        assert Enum.any?(order_book.bids)
        assert order_book.last_update_id != nil
      end
    end

    test "returns an error tuple when the symbol doesn't exist" do
      use_cassette "spot/public/depth_error" do
        assert Public.depth("IDONTEXIST", 1000) == {:error, :bad_symbol}
      end
    end
  end
end
