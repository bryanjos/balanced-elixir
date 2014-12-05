defmodule Balanced.API.Cards do
  alias Balanced.API.Base
  
  @endpoint "cards"
  @data_struct Balanced.Card
  @collection_name String.to_atom(@endpoint)

  @doc """
  Creates a new card
  """
  @spec create(pid, @data_struct.t) :: Balanced.response
  def create(balanced, card) do
    Base.post(balanced, @endpoint, card, @data_struct, @collection_name)
  end

  @doc """
  Gets the specified card
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Gets a list of cards
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

  @doc """
  Updates a card
  """
  @spec update(pid, binary, map, map) :: Balanced.response
  def update(balanced, id, meta, links) do
    Base.put(balanced, "#{@endpoint}/#{id}", %{meta: meta, links: links}, @data_struct, @collection_name)
  end

  @doc """
  Deletes a card
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Debits a card
  """
  @spec debit(pid, binary, Debit.t) :: Balanced.response
  def debit(balanced, id, debit) do
    Base.post(balanced, "#{@endpoint}/#{id}/debits", debit, Balanced.Debit, :debits)
  end

end