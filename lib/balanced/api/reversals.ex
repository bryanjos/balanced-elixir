defmodule Balanced.API.Reversals do
  use Balanced.API
  
  @endpoint "reversals"

  @doc """
  Gets a reversal
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Reversal, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of reversals
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Reversal, String.to_atom(@endpoint))
  end

  @doc """
  Creates a reversal
  """
  @spec create(pid, binary, Balanced.Reversal.t) :: Balanced.response
  def create(balanced, credit_id, reversal) do
    Http.post(balanced, "credits/#{credit_id}/#{@endpoint}", reversal)
    |> Balanced.API.to_response(Balanced.Reversal, String.to_atom(@endpoint))
  end

  @doc """
  Updates a reversal
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
    |> Balanced.API.to_response(Balanced.Reversal, String.to_atom(@endpoint))
  end

end