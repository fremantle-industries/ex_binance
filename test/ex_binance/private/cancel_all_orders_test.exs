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

  describe ".cancel_all_orders_for_a_pair" do
    test "returns an ok tuple with the response" do
      use_cassette "private/cancel_all_orders_for_a_pair" do
        assert {:ok, response} = ExBinance.Private.cancel_all_orders("LTCBTC", @credentials)

        assert [
                 %ExBinance.Rest.Responses.CancelOrderResponse{
                    client_order_id: "KIrygabcq9UbzzfzmsxjfB",
                    cummulative_quote_qty: "0.00000000",
                    executed_qty: "0.00000000",
                    order_id: 1430,
                    orig_client_order_id: "Rssxi0i3iqata5mLCaUU49",
                    orig_qty: "0.10000000",
                    price: "0.01000000",
                    side: "BUY",
                    status: "CANCELED",
                    symbol: "LTCBTC",
                    time_in_force: "GTC",
                    type: "LIMIT"
                 },
                 %ExBinance.Rest.Responses.CancelOrderResponse{
                    client_order_id: "KIrygabcq9UbzzfzmsxjfB",
                    cummulative_quote_qty: "0.00000000",
                    executed_qty: "0.00000000",
                    order_id: 1423,
                    orig_client_order_id: "TEST-ORDER-FOR-QUERY",
                    orig_qty: "0.10000000",
                    price: "0.01000000",
                    side: "BUY",
                    status: "CANCELED",
                    symbol: "LTCBTC",
                    time_in_force: "GTC",
                    type: "LIMIT"
                 },
                 %ExBinance.Rest.Responses.CancelOrderResponse{
                  client_order_id: "KIrygabcq9UbzzfzmsxjfB",
                  cummulative_quote_qty: "0.00015010",
                  executed_qty: "0.01501000",
                  order_id: 1421,
                  orig_client_order_id: "TEST-ORDER",
                  orig_qty: "0.10000000",
                  price: "0.01000000",
                  side: "BUY",
                  status: "CANCELED",
                  symbol: "LTCBTC",
                  time_in_force: "GTC",
                  type: "LIMIT"
               }
               ] = response
      end
    end
  end
end
