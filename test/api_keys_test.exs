defmodule APIKeysTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new("secret_key")
    {:ok, [balanced: balanced] }
  end

  test "create API key", context do
    use_cassette "api_key_create" do
      {status, response} = Balanced.APIKeys.create(context[:balanced])
      assert(status == :ok)
      id = hd(response["api_keys"])["id"]
      assert id == "AK1S2NqKVr1LdgTe6LqKdtS0"
    end
  end

  test "get API key", context do
    use_cassette "api_key_get" do
      {status, _} = Balanced.APIKeys.get(context[:balanced], "AK1S2NqKVr1LdgTe6LqKdtS0")
      assert(status == :ok)
    end
  end

  test "list API keys", context do
    use_cassette "api_key_list" do
      {status, _} = Balanced.APIKeys.list(context[:balanced])
      assert(status == :ok)
    end
  end

  test "delete API key", context do
    use_cassette "api_key_delete" do
      {status, _} = Balanced.APIKeys.delete(context[:balanced], "AK1S2NqKVr1LdgTe6LqKdtS0")
      assert(status == :ok)
    end
  end
end