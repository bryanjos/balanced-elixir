defmodule Balanced.Customers do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "customers"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def delete(id), do: Base.delete(@endpoint, id)

  def create(create_customer_request) do
    Http.post(@endpoint, create_customer_request)
  end

  def update(id, update_customer_request) do
    Http.put("#{@endpoint}/#{id}", update_customer_request)
  end

  def add_card(id, card_id), do: Http.put("cards/#{card_id}", [customer: "/customers/#{id}"])

  def add_bank_account(id, bank_account_id), do: Http.put("bank_accounts/#{bank_account_id}", [customer: "/customers/#{id}"])

end