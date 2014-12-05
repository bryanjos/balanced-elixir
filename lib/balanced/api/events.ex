defmodule Balanced.API.Events do
  alias Balanced.API.Base

  @endpoint "events"
  @data_struct Balanced.Event
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a event
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Gets a list of events
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

end