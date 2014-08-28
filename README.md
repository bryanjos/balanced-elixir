# Balanced-Elixir

Balanced API v1.1 Client for Elixir

All calls return either {:ok, response} or {:error, response} where response is a map of the Balanced API response

Usage:

use the following:
```
{:balanced, "~> 2.0.0"}
```

Usage:
```
  # In your config file, add a line for balanced config options
  config :balanced, secret_key: "<your_key>", time_out: <timeout, optional, defaults to 7000>

defmodule MyModule do

  	def do_stuff() do
      bar = %CreateBankAccountRequest{name: "Jon Doe", account_number: "account_number", routing_number: "routing_number", account_type: "checking"}
      {status, response} = Balanced.BankAccounts.create(bar)
  		Balanced.BankAccounts.list()
  	end
end
```
