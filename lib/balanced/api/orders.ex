defmodule Balanced.API.Orders do
  use Balanced.API
  
  @endpoint "orders"

  @doc """
  Gets an order
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Order, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of orders
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Order, String.to_atom(@endpoint))
  end

  @doc """
  Creates an order
  """
  @spec create(pid, binary, Balanced.Order.t) :: Balanced.response
  def create(balanced, customer_id, order) do
    Http.post(balanced, "customers/#{customer_id}/#{@endpoint}", order)
    |> Balanced.API.to_response(Balanced.Order, String.to_atom(@endpoint))
  end

  @doc """
  Updates an order
  """
  @spec update(pid, binary, binary, map) :: Balanced.response
  def update(balanced, id, description, meta) do
    Http.post(balanced, "#{@endpoint}/#{id}", %{description: description, meta: meta})
    |> Balanced.API.to_response(Balanced.Order, String.to_atom(@endpoint))
  end

end