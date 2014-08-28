defmodule Balanced.Orders do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "orders"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def create(customer_id, create_order_request) do
    Http.post("customers/#{customer_id}/#{@endpoint}", create_order_request)
  end

  def update(id, update_resource_request) do
    Http.put("#{@endpoint}/#{id}", update_resource_request)
  end

end