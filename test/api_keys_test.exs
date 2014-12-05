defmodule APIKeysTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    {:ok, [balanced: balanced] }
  end

  test "create API key", context do
    use_cassette "api_key_create" do
      {status, _} = Balanced.API.APIKeys.create(context[:balanced])
      assert status == :ok
    end
  end

  test "get API key", context do
    use_cassette "api_key_get" do
      {:ok, response} = Balanced.API.APIKeys.create(context[:balanced])
      id = hd(response.api_keys).id
      {status, _} = Balanced.API.APIKeys.get(context[:balanced], id)
      assert status == :ok
    end
  end

  test "get nonexisting API key", context do
    use_cassette "api_key_get_unknown" do
      {status, response} = Balanced.API.APIKeys.get(context[:balanced], "1")
      assert status == :error
      assert response.errors != nil
      assert hd(response.errors).status == "Not Found"
    end
  end

  test "list API keys", context do
    use_cassette "api_key_list" do
      {status, _} = Balanced.API.APIKeys.list(context[:balanced])
      assert status == :ok
    end
  end

  test "delete API key", context do
    use_cassette "api_key_delete" do
      {:ok, response} = Balanced.API.APIKeys.create(context[:balanced])
      id = hd(response.api_keys).id
      {status, _} = Balanced.API.APIKeys.delete(context[:balanced], id)
      assert status == :ok
    end
  end
end