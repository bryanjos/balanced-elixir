defmodule CardsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    {:ok, balanced } = Balanced.new(Application.get_env(:balanced, :secret_key, "secret_key"))
    {:ok, [balanced: balanced, test_card: %Balanced.Card{ number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123" }] }
  end

  test "create card", context do
    use_cassette "card_create" do
      {status, _} = Balanced.API.Cards.create(context[:balanced], context[:test_card])
      assert(status == :ok)
    end
  end


  test "get card", context do
    use_cassette "card_get" do
      {status, response} = Balanced.API.Cards.create(context[:balanced], context[:test_card])
      id = hd(response.cards).id

      {status, _} = Balanced.API.Cards.get(context[:balanced], id)
      assert(status == :ok)
    end
  end

  test "list cards", context do
    use_cassette "card_list" do
      {status, _} = Balanced.API.Cards.list(context[:balanced])
      assert(status == :ok)
    end
  end

  test "debit card", context do
    use_cassette "card_debit" do
      {status, response} = Balanced.API.Cards.create(context[:balanced], context[:test_card])
      id = hd(response.cards).id

      nb = %Balanced.Debit{amount: 500}
      {status, _} = Balanced.API.Cards.debit(context[:balanced], id, nb)
      assert(status == :ok)
    end
  end

  test "delete card", context do
    use_cassette "card_delete" do
      {status, response} = Balanced.API.Cards.create(context[:balanced], context[:test_card])
      id = hd(response.cards).id
      
      {status, _} = Balanced.API.Cards.delete(context[:balanced], id)
      assert(status == :ok)
    end
  end


end