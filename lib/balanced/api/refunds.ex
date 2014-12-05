defmodule Balanced.API.Refunds do
  alias Balanced.API.Base
  
  @endpoint "refunds"
  @struct Balanced.Refund
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a refund
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Gets a list of refunds
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @struct, @collection_name)
  end

  @doc """
  Creates a refund
  """
  @spec create(pid, binary, @struct.t) :: Balanced.response
  def create(balanced, debit_id, refund) do
    Base.post(balanced, "debits/#{debit_id}/#{@endpoint}", refund, @struct, @collection_name)
  end

  @doc """
  Updates a refund
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Base.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta}, @struct, @collection_name)
  end

end