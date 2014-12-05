defmodule Balanced.API.Cards do
  use Balanced.API
  
  @endpoint "cards"

  @doc """
  Creates a new card
  """
  @spec create(pid, Balanced.Card.t) :: Balanced.response
  def create(balanced, card) do
    Http.post(balanced, @endpoint, card)
    |> Balanced.API.to_response(Balanced.Card, String.to_atom(@endpoint))
  end

  @doc """
  Gets the specified card
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Card, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of cards
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Card, String.to_atom(@endpoint))
  end

  @doc """
  Updates a card
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links})
    |> Balanced.API.to_response(Balanced.Card, String.to_atom(@endpoint))
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
    |> Balanced.API.to_response(Balanced.Debit, :debits)
  end

end