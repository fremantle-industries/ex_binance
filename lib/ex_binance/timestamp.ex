defmodule ExBinance.Timestamp do
  def now(), do: System.os_time(:millisecond)
end
