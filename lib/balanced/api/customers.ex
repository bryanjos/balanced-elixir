defmodule Balanced.API.Customers do
  use Balanced.API
  
  @endpoint "customers"

  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

  def create(balanced, create_customer) do
    Http.post(balanced, @endpoint, create_customer)
  end

  def update(balanced, id, update_customer) do
    Http.put(balanced, "#{@endpoint}/#{id}", update_customer)
  end

  def add_card(balanced, id, card_id) do
    Http.put(balanced, "cards/#{card_id}", [customer: "/customers/#{id}"])
  end

  def add_bank_account(balanced, id, bank_account_id) do
    Http.put(balanced, "bank_accounts/#{bank_account_id}", [customer: "/customers/#{id}"])
  end

end