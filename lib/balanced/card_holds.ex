defmodule Balanced.CardHolds do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "card_holds"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def create(card_id, amount) do
    Http.post("cards/#{card_id}/#{@endpoint}", [amount: amount])
  end

  def update(id, update_resource_request) do
    Http.put("#{@endpoint}/#{id}", update_resource_request)
  end

  def debit(id, create_debit_request) do
    Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
  end

  def void(id), do: Http.put("#{@endpoint}/#{id}", [is_void: true])

end