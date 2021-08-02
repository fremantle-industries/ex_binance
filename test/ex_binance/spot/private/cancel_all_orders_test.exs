defmodule ExBinance.Spot.Private.CancelAllOrdersTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBinance.Spot.Private

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  describe ".cancel_all_orders_for_a_pair" do
    test "returns an ok tuple with the response" do
      use_cassette "spot/private/cancel_all_orders_for_a_pair" do
        assert {:ok, response} = Private.cancel_all_orders("LTCBTC", @credentials)
        assert [order_response_1, order_response_2] = response

        assert order_response_1 ==
                 %Private.Responses.CancelOrderResponse{
                   client_order_id: "pXLV6Hz6mprAcVYpVMTGgx",
                   cummulative_quote_qty: "0.000000",
                   executed_qty: "0.000000",
                   order_id: 13,
                   orig_client_order_id: "A3EF2HCwxgZPFMrfwbgrhv",
                   orig_qty: "0.178622",
                   price: "0.090430",
                   side: "BUY",
                   status: "CANCELED",
                   symbol: "BTCUSDT",
                   time_in_force: "GTC",
                   type: "LIMIT"
                 }

        assert order_response_2 ==
                 %Private.Responses.CancelOrderResponse{
                   client_order_id: "pXLV6Hz6mprAcVYpVMTGgx",
                   cummulative_quote_qty: "0.000000",
                   executed_qty: "0.000000",
                   order_id: 11,
                   orig_client_order_id: "E6APeyTJvkMvLMYMqu1KQ4",
                   orig_qty: "0.178622",
                   price: "0.089853",
                   side: "BUY",
                   status: "CANCELED",
                   symbol: "BTCUSDT",
                   time_in_force: "GTC",
                   type: "LIMIT"
                 }
      end
    end
  end
end
