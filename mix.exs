defmodule Balanced.Mixfile do
  use Mix.Project

  def project do
    [ app: :balanced,
      version: "1.1.0",
      elixir: "~> 0.12.4",
      deps: deps,
      source_url: "https://github.com/bryanjos/balanced-elixir"  ]
  end

  def application do
    [applications: [:httpotion]]
  end

  defp deps do
    [
      {:httpotion, github: "myfreeweb/httpotion"},
      {:json, github: "cblage/elixir-json"}
    ]
  end
end
