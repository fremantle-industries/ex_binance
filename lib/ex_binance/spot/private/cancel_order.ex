defmodule ExBinance.Spot.Private.CancelOrder do
  import ExBinance.Rest.SpotClient, only: [delete: 3]
  alias ExBinance.Rest.SpotClient
  alias ExBinance.Spot.Private.Responses
  alias ExBinance.Timestamp

  @type symbol :: String.t()
  @type order_id :: String.t()
  @type client_order_id :: String.t()
  @type credentials :: ExBinance.Credentials.t()
  @type response :: Responses.CancelOrderResponse.t()
  @type error_msg :: String.t()
  @type error_reason :: {:not_found, error_msg} | SpotClient.shared_errors()

  @path "/api/v3/order"
  @receiving_window 5000

  @spec cancel_order_by_order_id(symbol, order_id, credentials) ::
          {:ok, response} | {:error, error_reason}
  def cancel_order_by_order_id(symbol, order_id, credentials) do
    params = %{
      symbol: symbol,
      orderId: order_id,
      timestamp: Timestamp.now(),
      recv_window: @receiving_window
    }

    @path
    |> delete(params, credentials)
    |> parse_response()
  end

  @spec cancel_order_by_client_order_id(symbol, client_order_id, credentials) ::
          {:ok, response} | {:error, error_reason}
  def cancel_order_by_client_order_id(symbol, client_order_id, credentials) do
    params = %{
      symbol: symbol,
      origClientOrderId: client_order_id,
      timestamp: Timestamp.now(),
      recv_window: @receiving_window
    }

    @path
    |> delete(params, credentials)
    |> parse_response()
  end

  defp parse_response({:ok, response}) do
    {:ok, Responses.CancelOrderResponse.new(response)}
  end

  defp parse_response({:error, {:binance_error, %{"code" => -2011, "msg" => msg}}}) do
    {:error, {:not_found, msg}}
  end

  defp parse_response({:error, _} = error) do
    error
  end
end
