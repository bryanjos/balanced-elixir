Code.ensure_loaded?(Hex) and Hex.start

defmodule Balanced.Mixfile do
  use Mix.Project

  def project do
    [ app: :balanced,
      version: "3.1.0",
      elixir: "~> 1.0.0",
      deps: deps,
      description: "Balanced API for Elixir",
      package: package,
      source_url: "https://github.com/bryanjos/balanced-elixir"  ]
  end

  def application do
    [applications: [:httpotion, :logger, :poison]]
  end

  defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse"},
      {:httpotion, "~> 0.2"},
      {:poison, "~> 1.2.1"},
      {:exvcr, "~> 0.3.5", only: :test},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev}
    ]
  end

  defp package do
    [ # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      contributors: ["Bryan Joseph"],
      licenses: ["MIT"],
      links: %{ "GitHub" => "https://github.com/bryanjos/balanced-elixir" }
    ]
  end
end
