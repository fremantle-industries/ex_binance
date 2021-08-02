defmodule ExBinance.Spot.Private.AccountTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  @credentials %ExBinance.Credentials{
    api_key: System.get_env("BINANCE_API_KEY"),
    secret_key: System.get_env("BINANCE_API_SECRET")
  }

  test ".account returns an ok tuple with the account" do
    use_cassette "spot/private/account_ok" do
      assert {:ok, %ExBinance.Account{} = account} = ExBinance.Spot.Private.account(@credentials)
      assert account.update_time != nil
    end
  end
end
