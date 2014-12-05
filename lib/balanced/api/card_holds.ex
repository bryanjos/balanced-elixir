defmodule Balanced.API.CardHolds do
  use Balanced.API
  
  @endpoint "card_holds"

  @doc """
  Creates a Card Hold
  """
  @spec create(pid, binary, CardHold.t) :: Balanced.response
  def create(balanced, card_id, card_hold) do
    Http.post(balanced, "cards/#{card_id}/#{@endpoint}", card_hold)
    |> Balanced.API.to_response(Balanced.CardHold, String.to_atom(@endpoint))
  end

  @doc """
  Gets a Card Hold
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.CardHold, String.to_atom(@endpoint))
  end

  @doc """
  Lists Card Holds
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.CardHold, String.to_atom(@endpoint))
  end

  @doc """
  Updates a Card Hold
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
    |> Balanced.API.to_response(Balanced.CardHold, String.to_atom(@endpoint))
  end

  @doc """
  Captures a previously created Card Hold. This creates a debit.
  """
  @spec capture(pid, binary, Balanced.Debit.t) :: Balanced.response
  def capture(balanced, id, debit) do
    Http.post(balanced, "#{@endpoint}/#{id}/debits", debit)
    |> Balanced.API.to_response(Balanced.Debit, :debits)
  end

  @doc """
  Cancels the hold.
  """
  @spec void(pid, binary) :: Balanced.response
  def void(balanced, id) do
    Http.delete(balanced, "#{@endpoint}/#{id}")
  end

end