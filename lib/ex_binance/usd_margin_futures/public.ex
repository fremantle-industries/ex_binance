defmodule ExBinance.UsdMarginFutures.Public do
  alias __MODULE__

  defdelegate ping, to: Public.Ping

  defdelegate server_time, to: Public.ServerTime
end
