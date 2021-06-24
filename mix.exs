defmodule ExBinance.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_binance,
      version: "0.0.9",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.1"},
      {:exconstructor, "~> 1.1"},
      {:hackney, "~> 1.17"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mock, "~> 0.3", only: :test},
      {:excoveralls, "~> 0.1", only: :test},
      {:exvcr, "~> 0.11", only: :test}
    ]
  end

  defp description, do: "Binance API Client for Elixir"

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-capital/ex_binance"}
    ]
  end
end
