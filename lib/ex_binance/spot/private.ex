defmodule ExBinance.Spot.Private do
  import ExBinance.Rest.HTTPClient, only: [get: 3]
  alias __MODULE__

  @type credentials :: ExBinance.Credentials.t()
  @type shared_errors :: ExBinance.Rest.HTTPClient.shared_errors()

  @spec account(credentials) :: {:ok, term} | {:error, shared_errors}
  def account(credentials) do
    with {:ok, data} <- get("/api/v3/account", %{}, credentials) do
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
              to: Private.CreateOrder

  defdelegate create_order(params, credentials), to: Private.CreateOrder

  defdelegate cancel_order_by_order_id(
                symbol,
                order_id,
                credentials
              ),
              to: Private.CancelOrder

  defdelegate cancel_order_by_client_order_id(
                symbol,
                client_order_id,
                credentials
              ),
              to: Private.CancelOrder

  defdelegate cancel_all_orders(symbol, credentials), to: Private.CancelAllOrders

  defdelegate query_order_by_order_id(symbol, order_id, credentials),
    to: Private.QueryOrder

  defdelegate query_order_by_client_order_id(symbol, client_order_id, credentials),
    to: Private.QueryOrder
end
