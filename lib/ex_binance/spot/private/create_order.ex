defmodule ExBinance.Spot.Private.CreateOrder do
  import ExBinance.Rest.SpotClient, only: [post: 3]
  alias ExBinance.Spot.Private.{Requests, Responses}
  alias ExBinance.{Timestamp, Credentials}

  @type request :: Requests.CreateOrderRequest.t()
  @type response :: Responses.CreateOrderResponse.t()
  @type params :: map
  @type credentials :: Credentials.t()
  @type error_reason :: {:new_order_rejected, String.t()} | term

  @path "/api/v3/order"
  @receiving_window 5000

  @spec create_order(request | params, credentials) :: {:ok, response} | {:error, error_reason}
  def create_order(%Requests.CreateOrderRequest{} = params, credentials) do
    params
    |> Map.from_struct()
    |> create_order(credentials)
  end

  def create_order(params, credentials) when is_map(params) do
    @path
    |> post(params, credentials)
    |> parse_response()
  end

  @deprecated "Use ExBinance.Rest.CreateOrder.create_order/2 instead."
  def create_order(symbol, side, type, quantity, price, time_in_force, credentials) do
    %{
      symbol: symbol,
      side: side,
      type: type,
      quantity: quantity,
      price: price,
      timeInForce: time_in_force,
      timestamp: Timestamp.now(),
      recv_window: @receiving_window
    }
    |> create_order(credentials)
  end

  defp parse_response({:ok, response}) do
    {:ok, Responses.CreateOrderResponse.new(response)}
  end

  defp parse_response({:error, {:binance_error, %{"code" => -2010, "msg" => msg}}}) do
    {:error, {:new_order_rejected, msg}}
  end

  defp parse_response({:error, _} = error), do: error
end
