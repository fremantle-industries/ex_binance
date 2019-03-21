defmodule ExBinance do
  alias ExBinance.Rest.HTTPClient

  # Server

  @doc """
  Pings binance API. Returns `{:ok, %{}}` if successful, `{:error, reason}` otherwise
  """
  def ping() do
    HTTPClient.get_binance("/api/v1/ping")
  end

  @doc """
  Get binance server time in unix epoch.

  Returns `{:ok, time}` if successful, `{:error, reason}` otherwise

  ## Example
  ```
  {:ok, 1515390701097}
  ```

  """
  def get_server_time() do
    case HTTPClient.get_binance("/api/v1/time") do
      {:ok, %{"serverTime" => time}} -> {:ok, time}
      err -> err
    end
  end

  def get_exchange_info() do
    case HTTPClient.get_binance("/api/v1/exchangeInfo") do
      {:ok, data} -> {:ok, ExBinance.ExchangeInfo.new(data)}
      err -> err
    end
  end

  # Ticker

  @doc """
  Get all symbols and current prices listed in binance

  Returns `{:ok, [%ExBinance.SymbolPrice{}]}` or `{:error, reason}`.

  ## Example
  ```
  {:ok,
    [%ExBinance.SymbolPrice{price: "0.07579300", symbol: "ETHBTC"},
     %ExBinance.SymbolPrice{price: "0.01670200", symbol: "LTCBTC"},
     %ExBinance.SymbolPrice{price: "0.00114550", symbol: "BNBBTC"},
     %ExBinance.SymbolPrice{price: "0.00640000", symbol: "NEOBTC"},
     %ExBinance.SymbolPrice{price: "0.00030000", symbol: "123456"},
     %ExBinance.SymbolPrice{price: "0.04895000", symbol: "QTUMETH"},
     ...]}
  ```
  """
  def get_all_prices() do
    case HTTPClient.get_binance("/api/v1/ticker/allPrices") do
      {:ok, data} ->
        {:ok, Enum.map(data, &ExBinance.SymbolPrice.new(&1))}

      err ->
        err
    end
  end

  @doc """
  Retrieves the bids & asks of the order book up to the depth for the given symbol

  Returns `{:ok, %{bids: [...], asks: [...], lastUpdateId: 12345}}` or `{:error, reason}`

  ## Example
  ```
  {:ok,
    %ExBinance.OrderBook{
      asks: [
        ["8400.00000000", "2.04078100", []],
        ["8405.35000000", "0.50354700", []],
        ["8406.00000000", "0.32769800", []],
        ["8406.33000000", "0.00239000", []],
        ["8406.51000000", "0.03241000", []]
      ],
      bids: [
        ["8393.00000000", "0.20453200", []],
        ["8392.57000000", "0.02639000", []],
        ["8392.00000000", "1.40893300", []],
        ["8390.09000000", "0.07047100", []],
        ["8388.72000000", "0.04577400", []]
      ],
      last_update_id: 113634395
    }
  }
  ```
  """
  def get_depth(symbol, limit) do
    case HTTPClient.get_binance("/api/v1/depth?symbol=#{symbol}&limit=#{limit}") do
      {:ok, data} -> {:ok, ExBinance.OrderBook.new(data)}
      err -> err
    end
  end

  # Account

  @doc """
  Fetches user account from binance

  Returns `{:ok, %ExBinance.Account{}}` or `{:error, reason}`.

  In the case of a error on binance, for example with invalid parameters, `{:error, {:binance_error, %{code: code, msg: msg}}}` will be returned.

  Please read https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-information-user_data to understand API
  """

  def get_account() do
    api_key = Application.get_env(:ex_binance, :api_key)
    secret_key = Application.get_env(:ex_binance, :secret_key)

    case HTTPClient.get_binance("/api/v3/account", %{}, secret_key, api_key) do
      {:ok, data} -> {:ok, ExBinance.Account.new(data)}
      error -> error
    end
  end
end
