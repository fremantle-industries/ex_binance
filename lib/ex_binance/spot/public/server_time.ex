defmodule ExBinance.Spot.Public.ServerTime do
  import ExBinance.Rest.HTTPClient, only: [get: 2]

  def server_time do
    with {:ok, %{"serverTime" => time}} <- get("/api/v3/time", %{}) do
      {:ok, time}
    end
  end
end
