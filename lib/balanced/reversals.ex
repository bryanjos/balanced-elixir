defmodule Balanced.Reversals do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "reversals"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def create(credit_id, amount) do
    Http.post("credits/#{credit_id}/#{@endpoint}", [amount: amount])
  end

  def update(id, update_resource_request) do
    Http.put("#{@endpoint}/#{id}", update_resource_request)
  end

end