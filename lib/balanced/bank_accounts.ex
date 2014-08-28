defmodule Balanced.BankAccounts do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  @endpoint "bank_accounts"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def delete(id), do: Base.delete(@endpoint, id)

  def create(create_bank_account_request) do
    Http.post(@endpoint, create_bank_account_request)
  end

  def update(id, update_bank_account_request) do
    Http.put("#{@endpoint}/#{id}", update_bank_account_request)
  end

  def debit(id, create_debit_request) do
    Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
  end

  def credit(id, credit_bank_account_request) do
    Http.post("#{@endpoint}/#{id}/credits", credit_bank_account_request)
  end

  def credits(id, limit \\ 0, offset \\ 0), do: Base.list("#{@endpoint}/#{id}/credits", limit, offset)

end