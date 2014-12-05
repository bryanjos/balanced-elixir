defmodule Balanced.API.BankAccounts do
  use Balanced.API
  
  @endpoint "bank_accounts"

  @doc """
  Creates a new bank account
  """
  @spec create(pid, Balanced.BankAccount.t) :: Balanced.response
  def create(balanced, bank_account) do
    Http.post(balanced, @endpoint, bank_account)
    |> Balanced.API.to_response(Balanced.BankAccount, String.to_atom(@endpoint))
  end

  @doc """
  Gets a bank account 
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.BankAccount, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of bank accounts
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.BankAccount, String.to_atom(@endpoint))
  end

  @doc """
  Updates a bank account
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links})
    |> Balanced.API.to_response(Balanced.BankAccount, String.to_atom(@endpoint))
  end

  @doc """
  Deletes a bank account
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

  @doc """
  Debits a bank account
  """
  @spec debit(pid, binary, Balanced.Debit.t) :: Balanced.response
  def debit(balanced, id, debit) do
    Http.post(balanced, "#{@endpoint}/#{id}/debits", debit)
    |> Balanced.API.to_response(Balanced.Debit, :debits)
  end

  @doc """
  Credits a bank account
  """
  @spec credit(pid, binary, Balanced.Credit.t) :: Balanced.response
  def credit(balanced, id, credit) do
    Http.post(balanced, "#{@endpoint}/#{id}/credits", credit)
    |> Balanced.API.to_response(Balanced.Credit, :credits)
  end

  @doc """
  List credits for a bank account
  """
  @spec credits(pid, binary, number, number) :: Balanced.response
  def credits(balanced, id, limit \\ 10, offset \\ 0) do
    Base.list(balanced, "#{@endpoint}/#{id}/credits", limit, offset)
    |> Balanced.API.to_response(Balanced.Credit, :credits)
  end

end