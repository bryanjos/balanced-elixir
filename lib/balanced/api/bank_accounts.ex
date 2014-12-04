defmodule Balanced.API.BankAccounts do
  use Balanced.API

  defmodule BankAccount do
    @type t :: %BankAccount{name: binary, account_number: binary, routing_number: binary, account_type: binary, address: Balanced.Address.t}
    defstruct name: nil, account_number: nil, routing_number: nil, account_type: nil, address: %Balanced.Address{}
  end

  defmodule Debit do
    @type t :: %Debit{amount: number, appears_on_statement_as: binary, source: binary, order: binary, description: binary, meta: map}
    defstruct amount: nil, appears_on_statement_as: nil, source: nil, order: nil, description: nil, meta: nil
  end

  defmodule Credit do
    @type t :: %Credit{amount: number, appears_on_statement_as: binary, order: binary, destination: binary}
    defstruct amount: nil, appears_on_statement_as: nil, order: nil, destination: nil
  end
  
  @endpoint "bank_accounts"

  @doc """
  Creates a new bank account
  """
  @spec create(pid, BankAccount.t) :: Balanced.response
  def create(balanced, bank_account) do
    Http.post(balanced, @endpoint, bank_account)
  end

  @doc """
  Gets a bank account 
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  @doc """
  Gets a list of bank accounts
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  @doc """
  Updates a bank account
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links})
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
  @spec debit(pid, binary, Debit.t) :: Balanced.response
  def debit(balanced, id, debit) do
    Http.post(balanced, "#{@endpoint}/#{id}/debits", debit)
  end

  @doc """
  Credits a bank account
  """
  @spec credit(pid, binary, Credit.t) :: Balanced.response
  def credit(balanced, id, credit) do
    Http.post(balanced, "#{@endpoint}/#{id}/credits", credit)
  end

  @doc """
  List credits for a bank account
  """
  @spec credits(pid, binary, number, number) :: Balanced.response
  def credits(balanced, id, limit \\ 10, offset \\ 0) do
    Base.list(balanced, "#{@endpoint}/#{id}/credits", limit, offset)
  end

end