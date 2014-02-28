# Balanced-Elixir

Balanced Api Client for Elixir

All calls return either {:ok, response} or {:error, response}

Usage:
```
defmodule MyModule do
  	use Balanced, secret: "my-secret", marketplace_id: "my-marketplace"

  	def do_stuff() do
      {status, response} = BankAccounts.create("john doe", "account_number", "routing_number")
  		BankAccounts.list()
  	end
end
```