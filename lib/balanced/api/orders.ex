defmodule Balanced.API.Orders do
  use Balanced.API
  
  @endpoint "orders"

  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  def create(balanced, customer_id, create_order) do
    Http.post(balanced, "customers/#{customer_id}/#{@endpoint}", create_order)
  end

  def update(balanced, id, update_resource) do
    Http.put(balanced, "#{@endpoint}/#{id}", update_resource)
  end

end