defmodule Balanced.API.Credits do
  use Balanced.API

  @endpoint "credits"

  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  def update(balanced, id, update_resource) do
    Http.post(balanced, "#{@endpoint}/#{id}", update_resource)
  end

end