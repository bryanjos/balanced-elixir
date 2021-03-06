# Balanced-Elixir

Balanced API v1.1 Client for Elixir

Usage:

use the following:
```elixir
{:balanced, "~> 3.1.0"}
```

[Documentation](http://hexdocs.pm/balanced)

Usage:
```elixir
#looks for an application variable in the `:balanced` app named `:secret_key` or an environment variable named BALANCED_SECRET_KEY
{:ok, balanced} = Balanced.new

#alternatively, you can pass in the secret key as well
{:ok, balanced} = Balanced.new("my_secret_key") 

#then pass in the balanced pid when calling functions
{status, response} = Balanced.BankAccounts.get(balanced, bank_account_id)
```

status is either `:ok` or `:error`

response is a Map converted from the json response from Balanced.

Information about the balanced api can be found at [http://docs.balancedpayments.com/1.1/api/](http://docs.balancedpayments.com/1.1/api/)

All calls return either {:ok, response} or {:error, response} where response is a map of the Balanced API response


