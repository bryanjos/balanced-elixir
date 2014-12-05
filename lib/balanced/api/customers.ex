defmodule Balanced.API.Customers do
  alias Balanced.API.Base
  
  @endpoint "customers"
  @struct Balanced.Customer
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a customer
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Lists customers
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @struct, @collection_name)
  end

  @doc """
  Deletes a customer
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Creates a customer
  """
  @spec create(pid, @struct.t) :: Balanced.response
  def create(balanced, customer) do
    Base.post(balanced, @endpoint, customer, @struct, @collection_name)
  end

  @doc """
  Updates a customer
  """
  @spec update(pid, binary, @struct.t) :: Balanced.response
  def update(balanced, id, customer) do
    Base.put(balanced, "#{@endpoint}/#{id}", customer, @struct, @collection_name)
  end

  @doc """
  Associates the customer with the card
  """
  @spec add_card(pid, binary, binary) :: Balanced.response
  def add_card(balanced, customer_id, card_id) do
    Base.put(balanced, "cards/#{card_id}", [customer: "/customers/#{customer_id}"], Balanced.Card, :cards)
  end

  @doc """
  Associates the customer with the bank account
  """
  @spec add_bank_account(pid, binary, binary) :: Balanced.response
  def add_bank_account(balanced, customer_id, bank_account_id) do
    Base.put(balanced, "bank_accounts/#{bank_account_id}", [customer: "/customers/#{customer_id}"], Balanced.BankAccount, :bank_accounts)
  end

end