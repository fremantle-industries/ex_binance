defmodule ExBinance.Private.QueryOrderTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  describe ".query_order" do
    test "can query an order" do
      new_order_req = %ExBinance.Rest.Requests.CreateOrderRequest{
                        symbol: "LTCBTC",
                        side: "BUY",
                        type: "LIMIT",
                        quantity: 0.1,
                        price: 0.01,
                        time_in_force: "GTC"
                      }

      use_cassette "create_order_before_querying_it" do
        assert {:ok, %ExBinance.Rest.Responses.CreateOrderResponse{} = create_order_response} =
                  ExBinance.Private.create_order(new_order_req, @credentials)

        assert create_order_response.client_order_id != nil
        assert create_order_response.executed_qty == "0.00000000"
        assert create_order_response.order_id != nil
        assert create_order_response.orig_qty != nil
        assert create_order_response.price != nil
        assert create_order_response.side == "BUY"
        assert create_order_response.status == "NEW"
        assert create_order_response.symbol != nil
        assert create_order_response.time_in_force == "GTC"
        assert create_order_response.transact_time != nil
        assert create_order_response.type == "LIMIT"

        # Now we query the order we just created
        use_cassette "query_order" do
          assert {:ok, %ExBinance.Rest.Responses.QueryOrderResponse{} = query_order_response} =
            ExBinance.Private.query_order(
              "LTCBTC",
              create_order_response.order_id,
              @credentials
            )

          assert query_order_response.client_order_id != nil
          assert query_order_response.executed_qty == "1.00000000"
          assert query_order_response.order_id == create_order_response.executed_qty
          assert query_order_response.orig_qty == "1.00000000"
          assert query_order_response.price != nil
          assert query_order_response.side == "BUY"
          assert query_order_response.status == "FILLED"
          assert query_order_response.symbol == "BTCUSDT"
          assert query_order_response.time_in_force == "GTC"
          assert query_order_response.type == "LIMIT"
          assert query_order_response.order_list_id == -1
          assert query_order_response.cummulative_quote_qty == "1060.53692218"
          assert query_order_response.stop_price == "0.00000000"
          assert query_order_response.iceberg_qty == "0.00000000"
          assert query_order_response.time == 1609339381664
          assert query_order_response.update_time == 1609339736341
          assert query_order_response.is_working == true
          assert query_order_response.orig_quote_order_qty == "0.00000000"

        end
      end
    end
  end
end
