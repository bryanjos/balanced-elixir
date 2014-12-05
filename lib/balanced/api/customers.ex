defmodule Balanced.API.Customers do
  use Balanced.API
  
  @endpoint "customers"

  @doc """
  Gets a customer
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Customer, String.to_atom(@endpoint))
  end

  @doc """
  Lists customers
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Customer, String.to_atom(@endpoint))
  end

  @doc """
  Deletes a customer
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

  @doc """
  Creates a customer
  """
  @spec create(pid, Balanced.Customer.t) :: Balanced.response
  def create(balanced, customer) do
    Http.post(balanced, @endpoint, customer)
    |> Balanced.API.to_response(Balanced.Customer, String.to_atom(@endpoint))
  end

  @doc """
  Updates a customer
  """
  @spec update(pid, binary, Balanced.Customer.t) :: Balanced.response
  def update(balanced, id, customer) do
    Http.put(balanced, "#{@endpoint}/#{id}", customer)
    |> Balanced.API.to_response(Balanced.Customer, String.to_atom(@endpoint))
  end

  @doc """
  Associates the customer with the card
  """
  @spec add_card(pid, binary, binary) :: Balanced.response
  def add_card(balanced, customer_id, card_id) do
    Http.put(balanced, "cards/#{card_id}", [customer: "/customers/#{customer_id}"])
    |> Balanced.API.to_response(Balanced.Card, String.to_atom(@endpoint))
  end

  @doc """
  Associates the customer with the bank account
  """
  @spec add_bank_account(pid, binary, binary) :: Balanced.response
  def add_bank_account(balanced, customer_id, bank_account_id) do
    Http.put(balanced, "bank_accounts/#{bank_account_id}", [customer: "/customers/#{customer_id}"])
    |> Balanced.API.to_response(Balanced.BankAccount, String.to_atom(@endpoint))
  end

end