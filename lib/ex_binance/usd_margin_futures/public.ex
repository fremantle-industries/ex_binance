defmodule ExBinance.UsdMarginFutures.Public do
  alias __MODULE__

  defdelegate ping, to: Public.Ping

  defdelegate server_time, to: Public.ServerTime

  defdelegate exchange_info, to: Public.ExchangeInfo
end
