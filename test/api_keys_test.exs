defmodule APIKeysTest do
    use ExUnit.Case, async: true

  setup_all do
     {:ok, response} = Balanced.APIKeys.create

    id = hd(response["api_keys"])["id"]

     on_exit({:id, id}, fn ->
        {:ok, _} = Balanced.APIKeys.delete(id)
    end)

     {:ok, [id: id]}   
  end

  test "get API key", context do
    id = context[:id]

    {status, _} = Balanced.APIKeys.get(id)
    assert(status == :ok)

  end

  test "list API keys" do

    {status, _} = Balanced.APIKeys.list()
    assert(status == :ok)

  end
end