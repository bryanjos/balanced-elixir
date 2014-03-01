defmodule BalancedElixirTest do
  	use ExUnit.Case, async: true
  	use Balanced, secret_key: System.get_env("BALANCED_SECRET_KEY")

  	setup_all do
  		{		:ok, 	
  				[
  					bank_account: BankAccounts.create("Jon Doe", "9900000002", "021000021", "checking"), 
  					credit_card: Cards.create("4111111111111111", "2016", "12", "123"),
  					customer: Customers.create("Jon Doe", meta: [cool_guy: true])
  				]
  		}
  	end

	test "get param string" do
		s = Http.dict_to_params([a: 1, b: 2, c: [d: 4]])
		assert(s == "a=1&b=2&c[d]=4")
	end

	test "get empty param string" do
		s = Http.dict_to_params([])
		assert(s == "")
	end

	test "list bank accounts" do
		{status, _} = BankAccounts.list()
		assert(status == :ok)
	end

	test "create and credit a bank account", context do
		{status, response} = context[:bank_account]
		assert(status == :ok)

		bank_id = response["id"]

		{status, _} = BankAccounts.credit(bank_id, 1000)
		assert(status == :ok)
	end

	test "create a card", context do
		{status, _} = context[:credit_card]
		assert(status == :ok)
	end

	test "Add a Card to a Customer and charge it", context do
		{status, response} = context[:customer]
		assert(status == :ok)

		id = response["id"]

		{status, response} = context[:credit_card]
		assert(status == :ok)

		card_id = response["id"]

		{status, _} = Customers.add_card(id, card_id)
		assert(status == :ok)

		{status, _} = Customers.debit(id, 1000)
		assert(status == :ok)
	end

	test "Add a Bank Account to a Customer", context do
		{status, _} = context[:customer]
		assert(status == :ok)

		id = response["id"]

		{status, response} = context[:bank_account]
		assert(status == :ok)

		bank_id = response["id"]

		{status, _} = Customers.add_bank_account(id, bank_id)
		assert(status == :ok)
	end

  	teardown_all context do
 		{_, response} = context[:bank_account]
		id = response["id"]

		{status, _} = BankAccounts.delete(id)
		assert(status == :ok)

		{status, response} = BankAccounts.get(id)
		assert(status == :error)
		assert(response["status"] == "Not Found")
		
		{_, response} = context[:credit_card]
		id = response["id"]

		{status, _} = Cards.delete(id)
		assert(status == :ok)

		{status, response} = Cards.get(id)
		assert(status == :error)
		assert(response["status"] == "Not Found")

		{_, response} = context[:customer]
		id = response["id"]

		#Cannot delete customers with transactions
		{status, _} = Customers.delete(id)
		assert(status == :error)

		:ok	
  	end
end
