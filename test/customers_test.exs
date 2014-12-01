defmodule CustomersTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    :ok  
  end

  test "create customer" do
    use_cassette "customer_create" do
      nc = %Balanced.CreateCustomerRequest{name: "Jon Doe", meta: [cool_guy: true]}
      {status, _} = Balanced.Customers.create(nc)
      assert(status == :ok)
    end
  end

  test "get customer" do
    use_cassette "customer_get" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      {status, _} = Balanced.Customers.get(id)
      assert(status == :ok)
    end
  end

  test "list customers" do
    use_cassette "customer_list" do
      {status, _} = Balanced.Customers.list()
      assert(status == :ok)
    end
  end

  test "update customer" do
    use_cassette "customer_update" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      uc = %Balanced.UpdateCustomerRequest{email: "jon@doe.com"}
      {status, _} = Balanced.Customers.update(id, uc)
      assert(status == :ok)
    end
  end

  test "delete customer" do
    use_cassette "customer_delete" do
      id = "CU1BZRIR7amOhVyJDuNFhtAN"
      {status, _} = Balanced.Customers.delete(id)
      assert(status == :ok)
    end
  end
end