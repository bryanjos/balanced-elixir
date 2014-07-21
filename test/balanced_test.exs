defmodule BalancedElixirTest do
  	use ExUnit.Case, async: true
  	use Balanced, secret_key: System.get_env("BALANCED_SECRET_KEY")

	test "get param string" do
		s = Http.dict_to_params([a: 1, b: 2, c: [d: 4]],"")
		assert(s == "a=1&b=2&c[d]=4")
	end

	test "get empty param string" do
		s = Http.dict_to_params([], "")
		assert(s == "")
	end

  test "struct to param string" do
    bar = %CreateBankAccountRequest{ name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking" }
    s = Http.dict_to_params(bar, "")
    assert(s == "account_number=9900000002&account_type=checking&name=Jon Doe&routing_number=021000021")
  end

  test "API Keys" do
    {status, response} = APIKeys.create
    assert(status == :ok)

    id = hd(response["api_keys"])["id"]

    {status, _} = APIKeys.get(id)
    assert(status == :ok)

    {status, _} = APIKeys.list()
    assert(status == :ok)

    {status, _} = APIKeys.delete(id)
    assert(status == :ok)
  end

	test "Bank Accounts" do
    bar = %CreateBankAccountRequest{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}

    {status, response} = BankAccounts.create(bar)
    assert(status == :ok)

    id = hd(response["bank_accounts"])["id"]

    {status, _} = BankAccounts.get(id)
    assert(status == :ok)

		{status, _} = BankAccounts.list()
		assert(status == :ok)

    {status, _} = BankAccounts.credit(id, %CreditBankAccountRequest{ amount: 1000 })
    assert(status == :ok)

    {status, _} = BankAccounts.delete(id)
    assert(status == :ok)
	end

  test "Credit Cards" do
    ncc = %CreateCardRequest{ number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123" }
    {status, response} = Cards.create(ncc)
    assert(status == :ok)

    id = hd(response["cards"])["id"]

    {status, _} = Cards.get(id)
    assert(status == :ok)

    {status, _} = Cards.list()
    assert(status == :ok)

    nb = %CreateDebitRequest{amount: 500}
    {status, _} = Cards.debit(id, nb)
    assert(status == :ok)

    {status, _} = Cards.delete(id)
    assert(status == :ok)
  end

  test "Customers" do
    nc = %CreateCustomerRequest{name: "Jon Doe", meta: [cool_guy: true]}
    {status, response} = Customers.create(nc)
    assert(status == :ok)

    id = hd(response["customers"])["id"]

    {status, _} = Customers.get(id)
    assert(status == :ok)

    {status, _} = Customers.list()
    assert(status == :ok)

    uc = %UpdateCustomerRequest{email: "jon@doe.com"}
    {status, _} = Customers.update(id, uc)
    assert(status == :ok)

    ncc = %CreateCardRequest{number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123"}
    {_, response} = Cards.create(ncc)
    card_id = hd(response["cards"])["id"]

    {status, _} = Customers.add_card(id, card_id)
    assert(status == :ok)

    bar = %CreateBankAccountRequest{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
    {_, response} = BankAccounts.create(bar)
    bank_id = hd(response["bank_accounts"])["id"]

    {status, _} = Customers.add_bank_account(id, bank_id)
    assert(status == :ok)

    {status, _} = Customers.delete(id)
    assert(status == :ok)
  end
end
