defmodule ExBinance.Spot.Private.Account do
  import ExBinance.Rest.SpotClient, only: [get: 3]
  alias ExBinance.Rest.SpotClient

  @type credentials :: ExBinance.Credentials.t()
  @type shared_errors :: SpotClient.shared_errors()

  @spec account(credentials) :: {:ok, term} | {:error, shared_errors}
  def account(credentials) do
    with {:ok, data} <- get("/api/v3/account", %{}, credentials) do
      {:ok, ExBinance.Account.new(data)}
    end
  end
end
