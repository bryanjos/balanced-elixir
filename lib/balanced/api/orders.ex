defmodule Balanced.API.Orders do
  alias Balanced.API.Base
  
  @endpoint "orders"
  @struct Balanced.Order
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets an order
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @struct, @collection_name)
  end

  @doc """
  Gets a list of orders
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @struct, @collection_name)
  end

  @doc """
  Creates an order
  """
  @spec create(pid, binary, @struct.t) :: Balanced.response
  def create(balanced, customer_id, order) do
    Base.post(balanced, "customers/#{customer_id}/#{@endpoint}", order, @struct, @collection_name)
  end

  @doc """
  Updates an order
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Base.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta}, @struct, @collection_name)
  end

end