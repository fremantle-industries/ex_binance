defmodule ExBinance.UsdMarginFutures.Public.ExchangeInfo do
  import ExBinance.Rest.UsdMarginFuturesClient, only: [get: 2]

  def exchange_info do
    with {:ok, data} <- get("/fapi/v1/exchangeInfo", %{}) do
      {:ok, ExBinance.ExchangeInfo.new(data)}
    end
  end
end
