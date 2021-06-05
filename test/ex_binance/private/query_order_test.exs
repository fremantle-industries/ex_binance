defmodule ExBinance.Private.QueryOrderTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  @client_order_id "TEST-ORDER-FOR-QUERY"

  describe ".query_order" do
    test "can query an order from client order id" do
      new_order_req = %ExBinance.Rest.Requests.CreateOrderRequest{
                        new_client_order_id: @client_order_id,
                        symbol: "LTCBTC",
                        side: "BUY",
                        type: "LIMIT",
                        quantity: 0.1,
                        price: 0.01,
                        time_in_force: "GTC",
                        timestamp: ExBinance.Timestamp.now()
                      }


      use_cassette "create_order_before_querying_it" do
        assert {:ok, %ExBinance.Rest.Responses.CreateOrderResponse{} = create_order_response} =
                  ExBinance.Private.create_order(new_order_req, @credentials)

        assert create_order_response.client_order_id == @client_order_id
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
      end

      # Now we query the order we just created
      use_cassette "query_order_from_client_order_id" do
        assert {:ok, %ExBinance.Rest.Responses.QueryOrderResponse{} = query_order_response} =
          ExBinance.Private.query_order_by_client_order_id(
            "LTCBTC",
            @client_order_id,
            @credentials
          )

        assert query_order_response.client_order_id == @client_order_id
        assert query_order_response.executed_qty == "0.00000000"
        assert query_order_response.order_id != nil
        assert query_order_response.orig_qty == "0.10000000"
        assert query_order_response.price != nil
        assert query_order_response.side == "BUY"
        assert query_order_response.status == "NEW"
        assert query_order_response.symbol == "LTCBTC"
        assert query_order_response.time_in_force == "GTC"
        assert query_order_response.type == "LIMIT"
        assert query_order_response.order_list_id == -1
        assert query_order_response.cummulative_quote_qty == "0.00000000"
        assert query_order_response.stop_price == "0.00000000"
        assert query_order_response.iceberg_qty == "0.00000000"
        assert query_order_response.time != nil
        assert query_order_response.update_time != nil
        assert query_order_response.is_working == true
        assert query_order_response.orig_quote_order_qty == "0.00000000"
      end
    end

    test "can query an order" do
      use_cassette "query_order_from_order_id" do
        assert {:ok, %ExBinance.Rest.Responses.QueryOrderResponse{} = query_order_response} =
          ExBinance.Private.query_order_by_order_id(
            "LTCBTC",
            1512,
            @credentials
          )

        assert query_order_response.order_id == 1512
      end
    end

  end
end
