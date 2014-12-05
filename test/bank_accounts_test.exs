defmodule BankAccountsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    {:ok, [balanced: balanced, test_account: %Balanced.BankAccount{name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking"}] }
  end

  test "create bank account", context do
    use_cassette "bank_account_create" do
      {status, _} = Balanced.API.BankAccounts.create(context[:balanced], context[:test_account])
      assert status == :ok
    end
  end

  test "create bank account with errors", context do
    use_cassette "bank_account_create_errors" do
      {status, _} = Balanced.API.BankAccounts.create(context[:balanced], %{ context[:test_account] | account_number: nil })
      assert status == :error
    end
  end

  test "get bank account", context do
    use_cassette "bank_account_get" do
      {status, response} = Balanced.API.BankAccounts.create(context[:balanced], context[:test_account])
      id = hd(response.bank_accounts).id

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
      {status, response} = Balanced.API.BankAccounts.create(context[:balanced], context[:test_account])
      id = hd(response.bank_accounts).id

      {status, _} = Balanced.API.BankAccounts.credit(context[:balanced], id, %Balanced.Credit{ amount: 1000 })
      assert status == :error
    end
  end

  test "delete bank account", context do
    use_cassette "bank_account_delete" do
      {status, response} = Balanced.API.BankAccounts.create(context[:balanced], context[:test_account])
      id = hd(response.bank_accounts).id

      {status, _} = Balanced.API.BankAccounts.delete(context[:balanced], id)
      assert status == :ok
    end
  end
end