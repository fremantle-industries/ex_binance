defmodule ExBinance.Rest.HTTPClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    HTTPoison.start()
  end

  test ".get_binance returns an error tuple and passes through the binance error when unhandled" do
    use_cassette "unhandled_error_code" do
      assert {:error, {:binance_error, reason}} =
               ExBinance.Rest.HTTPClient.get_binance(
                 "/api/v1/time",
                 %{},
                 "invalid-secret-key",
                 "invalid-api-key"
               )

      assert %{"code" => _, "msg" => _} = reason
    end
  end

  [:timeout, :connect_timeout]
  |> Enum.each(fn error_reason ->
    @error_reason error_reason

    test ".get_binance returns an error tuple for #{error_reason} errors" do
      with_mock HTTPoison,
        get: fn _url, _headers -> {:error, %HTTPoison.Error{reason: @error_reason}} end do
        assert {:error, reason} =
                 ExBinance.Rest.HTTPClient.get_binance(
                   "/api/v1/time",
                   %{},
                   "invalid-secret-key",
                   "invalid-api-key"
                 )

        assert reason == @error_reason
      end
    end
  end)
end
