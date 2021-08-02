defmodule ExBinance.Spot.Public.ExchangeInfo do
  import ExBinance.Rest.HTTPClient, only: [get: 2]

  def exchange_info do
    with {:ok, data} <- get("/api/v3/exchangeInfo", %{}) do
      {:ok, ExBinance.ExchangeInfo.new(data)}
    end
  end
end
