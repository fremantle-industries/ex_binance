defmodule ExBinance.CoinMarginFutures.Public.PingTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.CoinMarginFutures.Public

  setup_all do
    HTTPoison.start()
  end

  test ".ping returns an empty map" do
    use_cassette "coin_margin_futures/public/ping_ok" do
      assert Public.ping() == {:ok, %{}}
    end
  end
end
