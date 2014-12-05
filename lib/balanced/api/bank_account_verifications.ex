defmodule Balanced.API.BankAccountVerifications do
  alias Balanced.API.Base
  
  @endpoint "verifications"
  @data_struct Balanced.BankAccountVerification
  @collection_name String.to_atom(@endpoint)

  @doc """
  Create a new bank account verification.
  """
  @spec create(pid, binary) :: Balanced.response
  def create(balanced, bank_account_id) do
    Base.post(balanced, "bank_accounts/#{bank_account_id}/#{@endpoint}", @data_struct, @collection_name)
  end

  @doc """
  Gets the verification for the bank account
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end


  @doc """
  Confirm the trial deposit amounts that were sent to the bank account.
  """
  @spec confirm(pid, binary, number, number) :: Balanced.response
  def confirm(balanced, id, amount_1, amount_2) do
    Base.put(balanced, "#{@endpoint}/#{id}", %{amount_1: amount_1, amount_2: amount_2}, @data_struct, @collection_name)
  end

end