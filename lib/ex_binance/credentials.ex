defmodule ExBinance.Credentials do
  @type t :: %ExBinance.Credentials{
          api_key: String.t(),
          secret_key: String.t()
        }

  @enforce_keys ~w(api_key secret_key)a
  defstruct ~w(api_key secret_key)a

  @doc """
  Generates credentials struct from configuration
  """
  def from_config do
    api_key = Application.get_env(:ex_binance, :api_key)
    secret_key = Application.get_env(:ex_binance, :secret_key)
    %__MODULE__{api_key: api_key, secret_key: secret_key}
  end
end
