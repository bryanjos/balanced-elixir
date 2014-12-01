defmodule APIKeysTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
 
    :ok
  end

  test "create API key" do
    use_cassette "api_key_create" do
      {status, response} = Balanced.APIKeys.create
      assert(status == :ok)
      id = hd(response["api_keys"])["id"]
      assert id == "AK1S2NqKVr1LdgTe6LqKdtS0"
    end
  end

  test "get API key" do
    use_cassette "api_key_get" do
      {status, _} = Balanced.APIKeys.get("AK1S2NqKVr1LdgTe6LqKdtS0")
      assert(status == :ok)
    end
  end

  test "list API keys" do
    use_cassette "api_key_list" do
      {status, _} = Balanced.APIKeys.list()
      assert(status == :ok)
    end
  end

  test "delete API key" do
    use_cassette "api_key_delete" do
      {status, _} = Balanced.APIKeys.delete("AK1S2NqKVr1LdgTe6LqKdtS0")
      assert(status == :ok)
    end
  end
end