defmodule ExBinance.CoinMarginFutures.Public.Ping do
  import ExBinance.Rest.CoinMarginFuturesClient, only: [get: 2]

  def ping, do: get("/dapi/v1/ping", %{})
end
