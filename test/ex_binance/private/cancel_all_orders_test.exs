defmodule ExBinance.Private.CancelAllOrdersTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }
  @order_id_1 13
  @order_id_2 11

  describe ".cancel_all_orders_for_a_pair" do
    test "returns an ok tuple with the response" do
      use_cassette "private/cancel_all_orders_for_a_pair" do
        assert {:ok, response} = ExBinance.Private.cancel_all_orders("LTCBTC", @credentials)

        assert [
                 %ExBinance.Rest.Responses.CancelOrderResponse{
                   client_order_id: "pXLV6Hz6mprAcVYpVMTGgx",
                   cummulative_quote_qty: "0.000000",
                   executed_qty: "0.000000",
                   order_id: @order_id_1,
                   orig_client_order_id: "A3EF2HCwxgZPFMrfwbgrhv",
                   orig_qty: "0.178622",
                   price: "0.090430",
                   side: "BUY",
                   status: "CANCELED",
                   symbol: "BTCUSDT",
                   time_in_force: "GTC",
                   type: "LIMIT"
                 },
                 %ExBinance.Rest.Responses.CancelOrderResponse{
                   client_order_id: "pXLV6Hz6mprAcVYpVMTGgx",
                   cummulative_quote_qty: "0.000000",
                   executed_qty: "0.000000",
                   order_id: @order_id_2,
                   orig_client_order_id: "E6APeyTJvkMvLMYMqu1KQ4",
                   orig_qty: "0.178622",
                   price: "0.089853",
                   side: "BUY",
                   status: "CANCELED",
                   symbol: "BTCUSDT",
                   time_in_force: "GTC",
                   type: "LIMIT"
                 }
               ] = response
      end
    end
  end
end
