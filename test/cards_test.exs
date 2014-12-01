defmodule CardsTest do
    use ExUnit.Case, async: false
    use ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("Basic\\s.+", "Basic SECRET_KEY")
    HTTPotion.start
    :ok 
  end

  test "create card" do
    use_cassette "card_create" do
      ncc = %Balanced.CreateCardRequest{ number: "4111111111111111", expiration_year: "2016", expiration_month: "12", cvv: "123" }
      {status, _} = Balanced.Cards.create(ncc)
      assert(status == :ok)
    end
  end


  test "get card" do
    use_cassette "card_get" do
      id = "CC2ggJAxZpx5qn0qJro7ykdL"
      {status, _} = Balanced.Cards.get(id)
      assert(status == :ok)
    end
  end

  test "list cards" do
    use_cassette "card_list" do
      {status, _} = Balanced.Cards.list()
      assert(status == :ok)
    end
  end

  test "debit card" do
    use_cassette "card_debit" do
      id = "CC2ggJAxZpx5qn0qJro7ykdL"
      nb = %Balanced.CreateDebitRequest{amount: 500}
      {status, _} = Balanced.Cards.debit(id, nb)
      assert(status == :ok)
    end
  end

  test "delete card" do
    use_cassette "card_delete" do
      id = "CC2ggJAxZpx5qn0qJro7ykdL"
      {status, _} = Balanced.Cards.delete(id)
      assert(status == :ok)
    end
  end


end