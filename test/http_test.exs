defmodule HttpTest do
    use ExUnit.Case, async: true

  test "get param string" do
    s = Balanced.API.Http.encode_params(%{ a: 1, b: 2, c: %{d: 4} }, "")
    assert(s == "a=1&b=2&c[d]=4")
  end

  test "get empty param string" do
    s = Balanced.API.Http.encode_params([], "")
    assert(s == "")
  end

  test "struct to param string" do
    bar = %Balanced.BankAccount{ name: "Jon Doe", account_number: "9900000002", routing_number: "021000021", account_type: "checking" }
    s = Balanced.API.Http.encode_params(bar, "")
    assert(s == "account_number=9900000002&account_type=checking&name=Jon Doe&routing_number=021000021")
  end
end