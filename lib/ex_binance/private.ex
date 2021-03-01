defmodule ExBinance.Private do
  import ExBinance.Rest.HTTPClient, only: [get_auth: 3]

  @type credentials :: ExBinance.Credentials.t()
  @type shared_errors :: ExBinance.Rest.HTTPClient.shared_errors()

  @spec account(credentials) :: {:ok, term} | {:error, shared_errors}
  def account(credentials) do
    with {:ok, data} <- get_auth("/api/v3/account", %{}, credentials) do
      {:ok, ExBinance.Account.new(data)}
    end
  end

  defdelegate create_order(
                symbol,
                side,
                type,
                quantity,
                price,
                time_in_force,
                credentials
              ),
              to: ExBinance.Rest.CreateOrder

  defdelegate create_order(
                params,
                credentials
              ),
              to: ExBinance.Rest.CreateOrder

  defdelegate cancel_order_by_order_id(
                symbol,
                order_id,
                credentials
              ),
              to: ExBinance.Rest.CancelOrder

  defdelegate cancel_all_orders(symbol, credentials), to: ExBinance.Rest.CancelAllOrders
end
