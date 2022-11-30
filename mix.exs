defmodule Dotor.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotor,
      version: "0.1.0",
      elixir: "~> 1.7.2",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dotor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:oauther, "~> 1.1"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.1"},
      {:json, "~> 1.4"},
      {:cors_plug, "~> 3.0"},
      {:mongodb_driver, "~> 0.9.2"},
      {:remote_ip, "~> 1.1"}
    ]
  end
end
