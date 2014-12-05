defmodule Balanced.API.Callbacks do
  alias Balanced.API.Base

  @type method :: :get | :post | :put
  
  @endpoint "callbacks"
  @struct Balanced.Callback
  @collection_name String.to_atom(@endpoint)

  @doc """
  Creates a callback to which events are sent.
  """
  @spec create(pid, binary, method) :: Balanced.response
  def create(balanced, url, method) do
    Base.post(balanced, @endpoint, %{ url: url, method: Atom.to_string(method) }, @struct, @collection_name)
  end

  @doc """
  Gets the specified callback
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Lists callbacks
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @struct, @collection_name)
  end

  @doc """
  Deletes the specified callback
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id, @struct, @collection_name)
  end

end