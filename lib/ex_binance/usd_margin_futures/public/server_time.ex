defmodule ExBinance.UsdMarginFutures.Public.ServerTime do
  import ExBinance.Rest.UsdMarginFuturesClient, only: [get: 2]

  def server_time do
    with {:ok, %{"serverTime" => time}} <- get("/fapi/v1/time", %{}) do
      {:ok, time}
    end
  end
end
