defmodule ExBinance.Spot.Public.Klines do
  import ExBinance.Rest.SpotClient, only: [get: 2]

  def klines(symbol, interval, limit \\ nil, start_time \\ nil, end_time \\ nil) do
    params =
      %{symbol: symbol, interval: interval}
      |> maybe_put(:limit, limit)
      |> maybe_put(:startTime, start_time)
      |> maybe_put(:endTime, end_time)

    with {:ok, data} <- get("/api/v3/klines", params) do
      {:ok, Enum.map(data, fn x -> ExBinance.Kline.new(build_kline_object(x)) end)}
    end
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp build_kline_object(kline_data) do
    %{
      :open_time => Enum.at(kline_data, 0),
      :open => Enum.at(kline_data, 1),
      :high => Enum.at(kline_data, 2),
      :low => Enum.at(kline_data, 3),
      :close => Enum.at(kline_data, 4),
      :volume => Enum.at(kline_data, 5),
      :close_time => Enum.at(kline_data, 6),
      :quote_asset_volume => Enum.at(kline_data, 7),
      :number_of_trades => Enum.at(kline_data, 8),
      :taker_buy_base_asset_volume => Enum.at(kline_data, 9),
      :taker_buy_quote_asset_volume => Enum.at(kline_data, 10)
    }
  end
end
