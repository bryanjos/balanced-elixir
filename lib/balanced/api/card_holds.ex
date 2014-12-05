defmodule Balanced.API.CardHolds do
  alias Balanced.API.Base
  
  @endpoint "card_holds"
  @data_struct Balanced.CardHold
  @collection_name String.to_atom(@endpoint)

  @doc """
  Creates a Card Hold
  """
  @spec create(pid, binary, @data_struct.t) :: Balanced.response
  def create(balanced, card_id, card_hold) do
    Base.post(balanced, "cards/#{card_id}/#{@endpoint}", card_hold, @data_struct, @collection_name)
  end

  @doc """
  Gets a Card Hold
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Lists Card Holds
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

  @doc """
  Updates a Card Hold
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Base.put(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta}, @data_struct, @collection_name)
  end

  @doc """
  Captures a previously created Card Hold. This creates a debit.
  """
  @spec capture(pid, binary, Balanced.Debit.t) :: Balanced.response
  def capture(balanced, id, debit) do
    Base.post(balanced, "#{@endpoint}/#{id}/debits", debit, Balanced.Debit, :debits)
  end

  @doc """
  Cancels the hold.
  """
  @spec void(pid, binary) :: Balanced.response
  def void(balanced, id) do
    Base.delete(balanced, "#{@endpoint}/#{id}", @data_struct, @collection_name)
  end

end