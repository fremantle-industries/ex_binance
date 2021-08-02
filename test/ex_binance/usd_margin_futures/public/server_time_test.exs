defmodule ExBinance.UsdMarginFutures.Public.ServerTimeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.UsdMarginFutures.Public

  setup_all do
    HTTPoison.start()
  end

  test ".server_time success return an ok, time tuple" do
    use_cassette "usd_margin_futures/public/server_time_ok" do
      {:ok, server_time} = Public.server_time()
      assert server_time > 0
    end
  end
end
