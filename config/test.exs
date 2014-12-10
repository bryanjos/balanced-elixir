use Mix.Config

config :logger,
   level: :debug,
   format: "$time $metadata[$level] $levelpad$message\n"

config :balanced, secret_key: "ak-test-ClKVXZ2mdMCdBZHULsAl53ZJKtuGTpqT"