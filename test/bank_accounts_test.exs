defmodule BankAccountsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new("secret_key")
    {:ok, [balanced: balanced] }
  end

  test "create bank account", context do
    use_cassette "bank_account_create" do
      bar = %Balanced.CreateBankAccount{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
      {status, _} = Balanced.BankAccounts.create(context[:balanced], bar)
      assert(status == :ok)
    end
  end

  test "get bank account", context do
    use_cassette "bank_account_get" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.get(context[:balanced], id)
      assert(status == :ok)
    end
  end

  test "list bank accounts", context do
    use_cassette "bank_account_list" do
      {status, _} = Balanced.BankAccounts.list(context[:balanced])
      assert(status == :ok)
    end
  end

  test "credit bank account", context do
    use_cassette "bank_account_credit" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.credit(context[:balanced], id, %Balanced.CreditBankAccount{ amount: 1000 })
      assert(status == :ok)
    end
  end

  test "delete bank account", context do
    use_cassette "bank_account_delete" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.BankAccounts.delete(context[:balanced], id)
      assert(status == :ok)
    end
  end
end