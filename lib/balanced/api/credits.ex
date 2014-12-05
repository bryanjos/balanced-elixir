defmodule Balanced.API.Credits do
  alias Balanced.API.Base

  @endpoint "credits"
  @struct Balanced.Credit
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a credit
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Gets a list of credits
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @struct, @collection_name)
  end

  @doc """
  Updates a credit
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Base.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta}, @struct, @collection_name)
  end

end