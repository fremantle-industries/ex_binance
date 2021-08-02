defmodule ExBinance.UsdMarginFutures.Public.ExchangeInfoTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.UsdMarginFutures.Public

  setup_all do
    HTTPoison.start()
  end

  test ".exchange_info success returns the trading rules and symbol information" do
    use_cassette "usd_margin_futures/public/exchange_info_ok" do
      assert {:ok, %ExBinance.ExchangeInfo{} = info} = Public.exchange_info()
      assert info.timezone == "UTC"
      assert info.server_time != nil
      assert Enum.any?(info.rate_limits)
      assert info.exchange_filters == []
      assert Enum.any?(info.symbols)
    end
  end
end
