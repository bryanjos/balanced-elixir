defmodule CardsTest do
    use ExUnit.Case, async: true

  setup_all do
    ncc = %Balanced.CreateCardRequest{ number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123" }
    {:ok, response} = Balanced.Cards.create(ncc)

    id = hd(response["cards"])["id"]

     on_exit({:id, id}, fn ->
        {:ok, _} = Balanced.Cards.delete(id)
    end)

     {:ok, [id: id, card: ncc]}   
  end

  test "get card", context do
    id = context[:id]
    {status, _} = Balanced.Cards.get(id)
    assert(status == :ok)

  end

  test "list cards" do

    {status, _} = Balanced.Cards.list()
    assert(status == :ok)

  end

  test "debit card", context do
    id = context[:id]
    nb = %Balanced.CreateDebitRequest{amount: 500}
    {status, _} = Balanced.Cards.debit(id, nb)
    assert(status == :ok)

  end
end