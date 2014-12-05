defmodule Balanced.API.Debits do
  use Balanced.API
  
  @endpoint "debits"

  @doc """
  Gets a debit
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Debit, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of debits
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Debit, String.to_atom(@endpoint))
  end

  @doc """
  Updates a debit
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
    |> Balanced.API.to_response(Balanced.Debit, String.to_atom(@endpoint))
  end

end