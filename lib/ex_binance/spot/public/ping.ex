defmodule ExBinance.Spot.Public.Ping do
  import ExBinance.Rest.SpotClient, only: [get: 2]

  def ping, do: get("/api/v3/ping", %{})
end
