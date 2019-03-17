defmodule ExBinance.InsufficientBalanceError do
  @enforce_keys [:reason]
  defstruct [:reason]
end
