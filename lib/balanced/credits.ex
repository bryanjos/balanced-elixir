defmodule Balanced.Credits do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http

  @endpoint "credits"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def update(id, update_resource_request) do
    Http.post("#{@endpoint}/#{id}", update_resource_request)
  end

end