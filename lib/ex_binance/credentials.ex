defmodule ExBinance.Credentials do
  @type t :: %ExBinance.Credentials{
          api_key: String.t(),
          secret_key: String.t()
        }

  @enforce_keys ~w(api_key secret_key)a
  defstruct ~w(api_key secret_key)a
end
