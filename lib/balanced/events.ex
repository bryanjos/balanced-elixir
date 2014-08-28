defmodule Balanced.Events do
  alias Balanced.Base, as: Base

  @endpoint "events"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

end