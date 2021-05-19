defmodule ExBinance.Private.CreateOrderTest do
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

  ["BUY", "SELL"]
  |> Enum.each(fn side ->
    @side side

    describe ".create_order #{side}" do
      test "can create a good till cancel order" do
        request = build_request(@side, "GTC")

        use_cassette "create_order_limit_#{@side}_good_til_cancel_success" do
          assert {:ok, %ExBinance.Rest.Responses.CreateOrderResponse{} = response} =
                   ExBinance.Private.create_order(request, @credentials)

          assert response.client_order_id != nil
          assert response.executed_qty == "0.00000000"
          assert response.order_id != nil
          assert response.orig_qty != nil
          assert response.price != nil
          assert response.side == @side
          assert response.status == "NEW"
          assert response.symbol != nil
          assert response.time_in_force == "GTC"
          assert response.transact_time != nil
          assert response.type == "LIMIT"
        end
      end

      test "can create a fill or kill order" do
        request = build_request(@side, "FOK")

        use_cassette "create_order_limit_#{@side}_fill_or_kill_success" do
          assert {:ok, %ExBinance.Rest.Responses.CreateOrderResponse{} = response} =
                   ExBinance.Private.create_order(request, @credentials)

          assert response.client_order_id != nil
          assert response.executed_qty == "0.00000000"
          assert response.order_id != nil
          assert response.orig_qty != nil
          assert response.price != nil
          assert response.side == @side
          assert response.status == "EXPIRED"
          assert response.symbol != nil
          assert response.time_in_force == "FOK"
          assert response.transact_time != nil
          assert response.type == "LIMIT"
        end
      end

      test "can create an immediate or cancel order" do
        request = build_request(@side, "IOC")

        use_cassette "create_order_limit_#{@side}_immediate_or_cancel_success" do
          assert {:ok, %ExBinance.Rest.Responses.CreateOrderResponse{} = response} =
                   ExBinance.Private.create_order(request, @credentials)

          assert response.client_order_id != nil
          assert response.executed_qty == "0.00000000"
          assert response.order_id != nil
          assert response.orig_qty != nil
          assert response.price != nil
          assert response.side == @side
          assert response.status == "EXPIRED"
          assert response.symbol != nil
          assert response.time_in_force == "IOC"
          assert response.transact_time != nil
          assert response.type == "LIMIT"
        end
      end

      test "returns an insufficient balance error tuple" do
        request = build_request(@side, "FOK")

        use_cassette "create_order_limit_#{@side}_error_insufficient_balance" do
          assert {:error, reason} = ExBinance.Private.create_order(request, @credentials)

          assert reason ==
                   {:insufficient_balance,
                    "Account has insufficient balance for requested action."}
        end
      end

      test "bubbles other errors" do
        error = {:error, %HTTPoison.Error{reason: :timeout}}
        request = build_request(@side, "FOK")

        with_mock HTTPoison,
          request: fn :post, _url, _body, _headers -> error end do
          assert ExBinance.Private.create_order(request, @credentials) ==
                   {:error, :timeout}
        end
      end
    end
  end)

  defp build_request(side, time_in_force) do
    %ExBinance.Rest.Requests.CreateOrderRequest{
      symbol: "LTCBTC",
      side: side,
      type: "LIMIT",
      quantity: 0.1,
      price: 0.01,
      time_in_force: time_in_force
    }
  end
end
