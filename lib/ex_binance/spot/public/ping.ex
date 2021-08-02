defmodule ExBinance.Spot.Public.Ping do
  import ExBinance.Rest.HTTPClient, only: [get: 2]

  def ping, do: get("/api/v3/ping", %{})
end
