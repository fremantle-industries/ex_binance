defmodule ExBinance.Private.CancelOrderTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  describe ".cancel_order_by_order_id" do
    test "returns an ok tuple with the response" do
      order_id = 165_812_252

      use_cassette "private/cancel_order_by_order_id_ok" do
        assert {:ok, response} =
                 ExBinance.Private.cancel_order_by_order_id("LTCBTC", order_id, @credentials)

        assert %ExBinance.Responses.CancelOrder{} = response
        assert response.order_id == order_id
      end
    end
  end
end
