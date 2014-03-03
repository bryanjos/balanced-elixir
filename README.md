# Balanced-Elixir

Balanced Api Client for Elixir

All calls return either {:ok, response} or {:error, response}

Usage:

For version 1.0 of the Balanced API, add the following to your deps:
```
{:balanced, github: "bryanjos/balanced-elixir", tag: "v1.0.2"}
```

For version 1.1, use the following:
```
{:balanced, github: "bryanjos/balanced-elixir"}
```

Usage:
```
defmodule MyModule do
  	use Balanced, secret_key: "my-secret", marketplace_id: "my-marketplace"

  	def do_stuff() do
      {status, response} = BankAccounts.create("john doe", "account_number", "routing_number")
  		BankAccounts.list()
  	end
end
```
