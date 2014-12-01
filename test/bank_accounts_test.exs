defmodule BankAccountsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    :ok   
  end

  test "create bank account" do
    use_cassette "bank_account_create" do
      bar = %Balanced.CreateBankAccountRequest{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
      {status, _} = Balanced.BankAccounts.create(bar)
      assert(status == :ok)
    end
  end

  test "get bank account" do
    use_cassette "bank_account_get" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.get(id)
      assert(status == :ok)
    end
  end

  test "list bank accounts" do
    use_cassette "bank_account_list" do
      {status, _} = Balanced.BankAccounts.list()
      assert(status == :ok)
    end
  end

  test "credit bank account" do
    use_cassette "bank_account_credit" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.credit(id, %Balanced.CreditBankAccountRequest{ amount: 1000 })
      assert(status == :ok)
    end
  end

  test "delete bank account" do
    use_cassette "bank_account_delete" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.delete(id)
      assert(status == :ok)
    end
  end
end