defmodule ExBinance.UsdMarginFutures.Public.PingTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.UsdMarginFutures.Public

  setup_all do
    HTTPoison.start()
  end

  test ".ping returns an empty map" do
    use_cassette "usd_margin_futures/public/ping_ok" do
      assert Public.ping() == {:ok, %{}}
    end
  end
end
