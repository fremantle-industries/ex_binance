import Config

config :ex_binance,
  domain: System.fetch_env!("BINANCE_API_DOMAIN"),
  api_key: System.fetch_env!("BINANCE_API_KEY"),
  secret_key: System.fetch_env!("BINANCE_API_SECRET")

config :exvcr,
  filter_request_headers: [
    "X-MBX-APIKEY"
  ],
  filter_sensitive_data: [
    [pattern: "signature=[A-Z0-9]+", placeholder: "signature=***"]
  ]
