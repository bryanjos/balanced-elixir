Code.ensure_loaded?(Hex) and Hex.start

defmodule Balanced.Mixfile do
  use Mix.Project

  def project do
    [ app: :balanced,
      version: "1.1.2",
      elixir: "~> 0.14.3",
      deps: deps,
      description: "Balanced API for Elixir",
      package: package,
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

  defp package do
    [ # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      contributors: ["Bryan Joseph"],
      licenses: ["MIT"],
      links: [ { "GitHub", "https://github.com/bryanjos/balanced-elixir" }]
    ]
  end
end
