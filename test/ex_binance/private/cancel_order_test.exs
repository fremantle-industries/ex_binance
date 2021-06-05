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
      order_id = 1512

      use_cassette "private/cancel_order_by_order_id_ok" do
        assert {:ok, response} =
                 ExBinance.Private.cancel_order_by_order_id("LTCBTC", order_id, @credentials)

        assert %ExBinance.Rest.Responses.CancelOrderResponse{} = response
        assert response.order_id == order_id
      end
    end

    test "returns an error tuple when the order id can't be found" do
      use_cassette "private/cancel_order_by_order_id_error_not_found" do
        assert {:error, {:not_found, msg}} =
                 ExBinance.Private.cancel_order_by_order_id("LTCBTC", "12345", @credentials)

        assert msg == "Unknown order sent."
      end
    end

  end
end
