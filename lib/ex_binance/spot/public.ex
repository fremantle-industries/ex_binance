defmodule ExBinance.Spot.Public do
  alias __MODULE__

  defdelegate ping, to: Public.Ping

  defdelegate server_time, to: Public.ServerTime

  defdelegate exchange_info, to: Public.ExchangeInfo

  defdelegate ticker_prices, to: Public.TickerPrices

  defdelegate depth(symbol, limit), to: Public.Depth

  defdelegate klines(symbol, interval, limit \\ nil, start_time \\ nil, end_time \\ nil),
    to: Public.Klines

  defdelegate recent_trades(symbol, limit), to: Public.Trades
end
