defmodule Balanced.BankAccountVerifications do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http
  
  @endpoint "verifications"

  def get(id), do: Base.get(@endpoint, id)

  def create(bank_account_id), do: Http.post("bank_accounts/#{bank_account_id}/#{@endpoint}")

  def confirm(id, confirm_bank_account_request) do
    Http.put("#{@endpoint}/#{id}", confirm_bank_account_request)
  end

end