defmodule Balanced.API.BankAccounts do
  alias Balanced.API.Base
  
  @endpoint "bank_accounts"
  @data_struct Balanced.BankAccount
  @collection_name String.to_atom(@endpoint)

  @doc """
  Creates a new bank account
  """
  @spec create(pid, @data_struct.t) :: Balanced.response
  def create(balanced, bank_account) do
    Base.post(balanced, @endpoint, bank_account, @data_struct, @collection_name)
  end

  @doc """
  Gets a bank account 
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Gets a list of bank accounts
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

  @doc """
  Updates a bank account
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Base.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links}, @data_struct, @collection_name)
  end

  @doc """
  Deletes a bank account
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Debits a bank account
  """
  @spec debit(pid, binary, Balanced.Debit.t) :: Balanced.response
  def debit(balanced, id, debit) do
    Base.post(balanced, "#{@endpoint}/#{id}/debits", debit, Balanced.Debit, :debits)
  end

  @doc """
  Credits a bank account
  """
  @spec credit(pid, binary, Balanced.Credit.t) :: Balanced.response
  def credit(balanced, id, credit) do
    Base.post(balanced, "#{@endpoint}/#{id}/credits", credit, Balanced.Credit, :credits)
  end

  @doc """
  List credits for a bank account
  """
  @spec credits(pid, binary, number, number) :: Balanced.response
  def credits(balanced, id, limit \\ 10, offset \\ 0) do
    Base.list(balanced, "#{@endpoint}/#{id}/credits", limit, offset, Balanced.Credit, :credits)
  end

end