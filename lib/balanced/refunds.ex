defmodule Balanced.Refunds do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "refunds"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def create(debit_id, create_refund_request) do
    Http.post("debits/#{debit_id}/#{@endpoint}", create_refund_request)
  end

  def update(id, update_resource_request) do
    Http.put("#{@endpoint}/#{id}", update_resource_request)
  end

end