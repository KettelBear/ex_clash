defmodule ExClash.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_clash,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ExClash",
      source_url: "https://github.com/kettelbear/ex_clash",
      homepage_url: "http://example.com",
      docs: [
        main: "ExClash", # The main page in the docs
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.4.0"},

      # Dev dependencies
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
    ]
  end
end
