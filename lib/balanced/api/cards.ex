defmodule Balanced.API.Cards do
  use Balanced.API
  
  @endpoint "cards"

  defmodule Card do
    @type t :: %Card{number: binary, expiration_year: number, expiration_month: number, cvv: binary, name: binary, address: Balanced.Address.t, customer: binary}
    defstruct number: nil, expiration_year: nil, expiration_month: nil, cvv: nil, name: nil, address: %Balanced.Address{}, customer: nil
  end

  defmodule Debit do
    @type t :: %Debit{amount: number, appears_on_statement_as: binary, source: binary, order: binary, description: binary, meta: map}
    defstruct amount: nil, appears_on_statement_as: nil, source: nil, order: nil, description: nil, meta: nil
  end

  defmodule Credit do
    @type t :: %Credit{amount: number, appears_on_statement_as: binary, order: binary, destination: binary}
    defstruct amount: nil, appears_on_statement_as: nil, order: nil, destination: nil
  end

  @doc """
  Creates a new card
  """
  @spec create(pid, Card.t) :: Balanced.response
  def create(balanced, card) do
    Http.post(balanced, @endpoint, card)
  end

  @doc """
  Gets the specified card
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
  end

  @doc """
  Gets a list of cards
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  @doc """
  Updates a card
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links})
  end

  @doc """
  Deletes a card
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

  @doc """
  Debits a card
  """
  @spec debit(pid, binary, Debit.t) :: Balanced.response
  def debit(balanced, id, debit) do
    Http.post(balanced, "#{@endpoint}/#{id}/debits", debit)
  end

end