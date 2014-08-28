defmodule CustomersTest do
    use ExUnit.Case, async: true

  setup_all do
    nc = %Balanced.CreateCustomerRequest{name: "Jon Doe", meta: [cool_guy: true]}
    {:ok, response} = Balanced.Customers.create(nc)

    id = hd(response["customers"])["id"]

     on_exit({:id, id}, fn ->
        {:ok, _} = Balanced.Customers.delete(id)
    end)

     {:ok, [id: id, customer: nc]}   
  end

  test "get customer", context do
    id = context[:id]
    {status, _} = Balanced.Customers.get(id)
    assert(status == :ok)

  end

  test "list customers" do

    {status, _} = Balanced.Customers.list()
    assert(status == :ok)

  end

  test "credit bank account", context do
    id = context[:id]
    {status, _} = Balanced.BankAccounts.credit(id, %Balanced.CreditBankAccountRequest{ amount: 1000 })
    assert(status == :ok)

  end

  test "update customer", context do
    id = context[:id]
    uc = %Balanced.UpdateCustomerRequest{email: "jon@doe.com"}
    {status, _} = Balanced.Customers.update(id, uc)
    assert(status == :ok)
  end

  test "add card to customer", context do
    id = context[:id]
    ncc = %Balanced.CreateCardRequest{number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123"}
    {_, response} = Balanced.Cards.create(ncc)
    card_id = hd(response["cards"])["id"]

    {status, _} = Balanced.Customers.add_card(id, card_id)
    assert(status == :ok)

  end

  test "add bank account to customer", context do
    id = context[:id]
    bar = %Balanced.CreateBankAccountRequest{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
    {_, response} = Balanced.BankAccounts.create(bar)
    bank_id = hd(response["bank_accounts"])["id"]

    {status, _} = Balanced.Customers.add_bank_account(id, bank_id)
    assert(status == :ok)
  end
end