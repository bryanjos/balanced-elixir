defmodule BankAccountsTest do
    use ExUnit.Case, async: true

  setup_all do
    bar = %Balanced.CreateBankAccountRequest{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
    {:ok, response} = Balanced.BankAccounts.create(bar)

    id = hd(response["bank_accounts"])["id"]

     on_exit({:id, id}, fn ->
        {:ok, _} = Balanced.BankAccounts.delete(id)
    end)

     {:ok, [id: id, account: bar]}   
  end

  test "get bank account", context do
    id = context[:id]
    {status, _} = Balanced.BankAccounts.get(id)
    assert(status == :ok)

  end

  test "list bank accounts" do
    {status, _} = Balanced.BankAccounts.list()
    assert(status == :ok)

  end

  test "credit bank account", context do
    id = context[:id]
    {status, _} = Balanced.BankAccounts.credit(id, %Balanced.CreditBankAccountRequest{ amount: 1000 })
    assert(status == :ok)

  end
end