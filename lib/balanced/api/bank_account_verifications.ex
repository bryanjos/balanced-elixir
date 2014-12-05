defmodule Balanced.API.BankAccountVerifications do
  use Balanced.API
  
  @endpoint "verifications"

  @doc """
  Create a new bank account verification.
  """
  @spec create(pid, binary) :: Balanced.response
  def create(balanced, bank_account_id) do
    Http.post(balanced, "bank_accounts/#{bank_account_id}/#{@endpoint}")
    |> Balanced.API.to_response(Balanced.BankAccountVerification, String.to_atom(@endpoint))
  end

  @doc """
  Gets the verification for the bank account
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.BankAccountVerification, String.to_atom(@endpoint))
  end


  @doc """
  Confirm the trial deposit amounts that were sent to the bank account.
  """
  @spec confirm(pid, binary, number, number) :: Balanced.response
  def confirm(balanced, id, amount_1, amount_2) do
    Http.put(balanced, "#{@endpoint}/#{id}", %{amount_1: amount_1, amount_2: amount_2})
    |> Balanced.API.to_response(Balanced.BankAccountVerification, String.to_atom(@endpoint))
  end

end