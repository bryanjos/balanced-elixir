defmodule Balanced.Mixfile do
  use Mix.Project

  def project do
    [ app: :balanced,
      version: "1.1.2",
      elixir: "~> 0.14.3",
      deps: deps,
      source_url: "https://github.com/bryanjos/balanced-elixir"  ]
  end

  def application do
    [applications: [:httpotion]]
  end

  defp deps do
    [
      {:httpotion, github: "myfreeweb/httpotion"},
      {:jsex, github: "talentdeficit/jsex"}
    ]
  end
end
