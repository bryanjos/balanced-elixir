# Balanced-Elixir

Balanced API v1.1 Client for Elixir

All calls return either {:ok, response} or {:error, response} where response is a map of the Balanced API response

Usage:

use the following:
```
{:balanced, github: "bryanjos/balanced-elixir"}
```

Usage:
```
defmodule MyModule do
  	use Balanced, secret_key: "my-secret", marketplace_id: "my-marketplace"

  	def do_stuff() do
      bar = %CreateBankAccountRequest{name: "Jon Doe", account_number: "account_number", routing_number: "routing_number", account_type: "checking"}
      {status, response} = BankAccounts.create(bar)
  		BankAccounts.list()
  	end
end
```
