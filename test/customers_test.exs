defmodule CustomersTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new("secret_key")
    {:ok, [balanced: balanced] }
  end

  test "create customer", context do
    use_cassette "customer_create" do
      nc = %Balanced.CreateCustomer{name: "Jon Doe", meta: [cool_guy: true]}
      {status, _} = Balanced.Customers.create(context[:balanced], nc)
      assert(status == :ok)
    end
  end

  test "get customer", context do
    use_cassette "customer_get" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      {status, _} = Balanced.Customers.get(context[:balanced], id)
      assert(status == :ok)
    end
  end

  test "list customers", context do
    use_cassette "customer_list" do
      {status, _} = Balanced.Customers.list(context[:balanced])
      assert(status == :ok)
    end
  end

  test "update customer", context do
    use_cassette "customer_update" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      uc = %Balanced.UpdateCustomer{email: "jon@doe.com"}
      {status, _} = Balanced.Customers.update(context[:balanced], id, uc)
      assert(status == :ok)
    end
  end

  test "delete customer", context do
    use_cassette "customer_delete" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      {status, _} = Balanced.Customers.delete(context[:balanced], id)
      assert(status == :ok)
    end
  end
end