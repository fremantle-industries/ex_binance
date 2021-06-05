defmodule ExBinance.Rest.HTTPClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    HTTPoison.start()
  end

  describe ".get" do
    test "returns an ok tuple with decoded json data" do
      use_cassette "get_ok" do
        assert {:ok, %{"serverTime" => _}} = ExBinance.Rest.HTTPClient.get("/api/v1/time", %{})
      end
    end

    [:timeout, :connect_timeout]
    |> Enum.each(fn error_reason ->
      @error_reason error_reason

      test "#{error_reason} returns an error tuple" do
        with_mock HTTPoison,
          get: fn _url, _headers -> {:error, %HTTPoison.Error{reason: @error_reason}} end do
          assert {:error, reason} = ExBinance.Rest.HTTPClient.get("/api/v1/time", %{})
          assert reason == @error_reason
        end
      end
    end)
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  test ".get returns an ok tuple with decoded json data for endpoints that require auth" do
    use_cassette "get_auth_ok" do
      assert {:ok, data} = ExBinance.Rest.HTTPClient.get("/api/v3/account", %{}, @credentials)

      assert %{"canTrade" => _} = data
    end
  end

  describe ".delete" do
    test "returns an error tuple when the timestamp is outside the receive window" do
      use_cassette "http_client/delete_error_receive_window" do
        params = %{
          symbol: "LTCBTC",
          orderId: "123",
          timestamp: ExBinance.Timestamp.now(),
          recvWindow: 1000
        }

        assert {:error, :receive_window} =
                 ExBinance.Rest.HTTPClient.delete("/api/v3/order", params, @credentials)
      end
    end
  end
end
