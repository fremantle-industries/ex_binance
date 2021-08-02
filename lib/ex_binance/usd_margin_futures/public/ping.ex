defmodule ExBinance.UsdMarginFutures.Public.Ping do
  import ExBinance.Rest.UsdMarginFuturesClient, only: [get: 2]

  def ping, do: get("/fapi/v1/ping", %{})
end
