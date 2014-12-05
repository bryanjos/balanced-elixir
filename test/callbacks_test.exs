defmodule CallbacksTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    test_callback = %Balanced.Callback{url: "http://www.example.com/callback", method: "get"}
    {:ok, [balanced: balanced, test_callback: test_callback] }
  end

  test "create callback", context do
    use_cassette "callback_create" do
      {status, _} = Balanced.API.Callbacks.create(context[:balanced], context[:test_callback])
      assert status == :ok
    end
  end

  test "get callback", context do
    use_cassette "callback_get" do
      {:ok, response} = Balanced.API.Callbacks.create(context[:balanced], %{ context[:test_callback] | url: "http://www.example.com/callback2"})
      id = hd(response.callbacks).id

      {status, _} = Balanced.API.Callbacks.get(context[:balanced], id)
      assert status == :ok
    end
  end

  test "list callbacks", context do
    use_cassette "callback_list" do
      {status, _} = Balanced.API.Callbacks.list(context[:balanced])
      assert status == :ok
    end
  end

  test "delete callbacks", context do
    use_cassette "callback_delete" do
      {:ok, response} = Balanced.API.Callbacks.create(context[:balanced], %{ context[:test_callback] | url: "http://www.example.com/callback3"})
      id = hd(response.callbacks).id

      {status, _} = Balanced.API.Callbacks.delete(context[:balanced], id)
      assert status == :ok
    end
  end
end