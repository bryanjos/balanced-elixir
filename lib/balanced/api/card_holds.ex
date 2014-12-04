defmodule Balanced.API.CardHolds do
  use Balanced.API
  
  @endpoint "card_holds"

  defmodule CardHold do
    @type t :: %CardHold{amount: number, description: binary, meta: map, order: binary}
    defstruct amount: nil, description: nil, meta: nil, order: nil
  end

  defmodule Debit do
    @type t :: %Debit{amount: number, appears_on_statement_as: binary, source: binary, order: binary, description: binary, meta: map}
    defstruct amount: nil, appears_on_statement_as: nil, source: nil, order: nil, description: nil, meta: nil
  end

  @doc """
  Creates a Card Hold
  """
  @spec create(pid, binary, CardHold.t) :: Balanced.response
  def create(balanced, card_id, card_hold) do
    Http.post(balanced, "cards/#{card_id}/#{@endpoint}", card_hold)
  end

  @doc """
  Gets a Card Hold
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
  end

  @doc """
  Lists Card Holds
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  @doc """
  Updates a Card Hold
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
  end

  @doc """
  Captures a previously created Card Hold. This creates a debit.
  """
  @spec capture(pid, binary, Debit.t) :: Balanced.response
  def capture(balanced, id, debit) do
    Http.post(balanced, "#{@endpoint}/#{id}/debits", debit)
  end

  @doc """
  Cancels the hold.
  """
  @spec void(pid, binary) :: Balanced.response
  def void(balanced, id) do
    Http.delete(balanced, "#{@endpoint}/#{id}")
  end

end