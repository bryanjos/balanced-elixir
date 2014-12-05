defmodule Balanced.API.Reversals do
  alias Balanced.API.Base
  
  @endpoint "reversals"
  @data_struct Balanced.Reversal
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a reversal
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Gets a list of reversals
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

  @doc """
  Creates a reversal
  """
  @spec create(pid, binary, @data_struct.t) :: Balanced.response
  def create(balanced, credit_id, reversal) do
    Base.post(balanced, "credits/#{credit_id}/#{@endpoint}", reversal, @data_struct, @collection_name)
  end

  @doc """
  Updates a reversal
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Base.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta}, @data_struct, @collection_name)
  end

end