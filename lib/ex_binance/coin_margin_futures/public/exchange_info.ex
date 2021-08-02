defmodule ExBinance.CoinMarginFutures.Public.ExchangeInfo do
  import ExBinance.Rest.CoinMarginFuturesClient, only: [get: 2]

  def exchange_info do
    with {:ok, data} <- get("/dapi/v1/exchangeInfo", %{}) do
      {:ok, ExBinance.ExchangeInfo.new(data)}
    end
  end
end
