defmodule Balanced.API.Events do
  use Balanced.API

  @endpoint "events"

  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
  end

  def list(balanced, limit \\ 0, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
  end

end