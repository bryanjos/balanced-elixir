defmodule Balanced.API.Refunds do
  use Balanced.API
  
  @endpoint "refunds"

  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  def create(balanced, debit_id, create_refund) do
    Http.post(balanced, "debits/#{debit_id}/#{@endpoint}", create_refund)
  end

  def update(balanced, id, update_resource) do
    Http.put(balanced, "#{@endpoint}/#{id}", update_resource)
  end

end