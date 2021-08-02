import Config

config :ex_binance,
  spot_domain: System.fetch_env!("BINANCE_API_SPOT_DOMAIN"),
  usd_margin_futures_domain: System.fetch_env!("BINANCE_API_USD_MARGIN_FUTURES_DOMAIN"),
  coin_margin_futures_domain: System.fetch_env!("BINANCE_API_COIN_MARGIN_FUTURES_DOMAIN"),
  api_key: System.fetch_env!("BINANCE_API_KEY"),
  secret_key: System.fetch_env!("BINANCE_API_SECRET")

config :exvcr,
  filter_request_headers: [
    "X-MBX-APIKEY"
  ],
  filter_sensitive_data: [
    [pattern: "signature=[A-Z0-9]+", placeholder: "signature=***"]
  ]
