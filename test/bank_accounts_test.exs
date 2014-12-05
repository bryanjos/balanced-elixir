defmodule BankAccountsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    {:ok, [balanced: balanced] }
  end

  test "create bank account", context do
    use_cassette "bank_account_create" do
      bar = %Balanced.BankAccount{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}
      {status, _} = Balanced.API.BankAccounts.create(context[:balanced], bar)
      assert status == :ok
    end
  end

  test "create bank account with errors", context do
    use_cassette "bank_account_create_errors" do
      bar = %Balanced.BankAccount{name: "Jon Doe", account_number: nil, routing_number: "021000021", account_type: "checking"}
      {status, _} = Balanced.API.BankAccounts.create(context[:balanced], bar)
      assert status == :error
    end
  end

  test "get bank account", context do
    use_cassette "bank_account_get" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.API.BankAccounts.get(context[:balanced], id)
      assert status == :ok
    end
  end

  test "list bank accounts", context do
    use_cassette "bank_account_list" do
      {status, _} = Balanced.API.BankAccounts.list(context[:balanced])
      assert status == :ok
    end
  end

  test "credit bank account", context do
    use_cassette "bank_account_credit" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.API.BankAccounts.credit(context[:balanced], id, %Balanced.Credit{ amount: 1000 })
      assert status == :ok
    end
  end

  test "delete bank account", context do
    use_cassette "bank_account_delete" do
      id = "BA548iQji5hZ4FyckgjLTcTC"
      {status, _} = Balanced.API.BankAccounts.delete(context[:balanced], id)
      assert status == :ok
    end
  end
end