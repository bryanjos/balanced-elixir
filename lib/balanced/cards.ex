defmodule Balanced.Cards do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "cards"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def delete(id), do: Base.delete(@endpoint, id)

  def create(create_card_request) do
    Http.post(@endpoint, create_card_request)
  end

  def update(id, update_card_request) do
    Http.put("#{@endpoint}/#{id}", update_card_request)
  end

  def debit(id, create_debit_request) do
    Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
  end

end