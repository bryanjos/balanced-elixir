defmodule Balanced.API.Disputes do
  use Balanced.API
  
  @endpoint "disputes"

  @doc """
  Gets a dispute
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Dispute, String.to_atom(@endpoint))
  end

  @doc """
  Gets a list of disputes
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Dispute, String.to_atom(@endpoint))
  end

end