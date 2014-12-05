defmodule CustomersTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    {:ok, [balanced: balanced, test_customer: %Balanced.Customer{name: "Jon Doe", meta: %{ cool_guy: true }}] }
  end

  test "create customer", context do
    use_cassette "customer_create" do
      {status, _} = Balanced.API.Customers.create(context[:balanced], context[:test_customer])
      assert(status == :ok)
    end
  end

  test "get customer", context do
    use_cassette "customer_get" do
      {status, response} = Balanced.API.Customers.create(context[:balanced], context[:test_customer])
      id = hd(response.customers).id

      {status, _} = Balanced.API.Customers.get(context[:balanced], id)
      assert(status == :ok)
    end
  end

  test "list customers", context do
    use_cassette "customer_list" do
      {status, _} = Balanced.API.Customers.list(context[:balanced])
      assert(status == :ok)
    end
  end

  test "update customer", context do
    use_cassette "customer_update" do
      {status, response} = Balanced.API.Customers.create(context[:balanced], context[:test_customer])
      id = hd(response.customers).id

      uc = %Balanced.Customer{email: "jon@doe.com"}
      {status, _} = Balanced.API.Customers.update(context[:balanced], id, uc)
      assert(status == :ok)
    end
  end
end