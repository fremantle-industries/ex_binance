defmodule ExBinance.Auth do
  def sign(secret_key, argument_string) do
    :hmac
    |> :crypto.mac(:sha256, secret_key, argument_string)
    |> Base.encode16()
  end
end
