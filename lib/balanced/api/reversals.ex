defmodule Balanced.API.Reversals do
  use Balanced.API
  
  @endpoint "reversals"

  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

  def create(balanced, credit_id, amount) do
    Http.post(balanced, "credits/#{credit_id}/#{@endpoint}", [amount: amount])
  end

  def update(balanced, id, update_resource) do
    Http.put(balanced, "#{@endpoint}/#{id}", update_resource)
  end

end