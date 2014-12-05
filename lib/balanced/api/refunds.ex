defmodule Balanced.API.Refunds do
  use Balanced.API
  
  @endpoint "refunds"

  @doc """
  Gets a refund
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Refund, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of refunds
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Refund, String.to_atom(@endpoint))
  end

  @doc """
  Creates a refund
  """
  @spec create(pid, binary, Balanced.Refund.t) :: Balanced.response
  def create(balanced, debit_id, refund) do
    Http.post(balanced, "debits/#{debit_id}/#{@endpoint}", refund)
    |> Balanced.API.to_response(Balanced.Refund, String.to_atom(@endpoint))
  end

  @doc """
  Updates a refund
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
    |> Balanced.API.to_response(Balanced.Refund, String.to_atom(@endpoint))
  end

end