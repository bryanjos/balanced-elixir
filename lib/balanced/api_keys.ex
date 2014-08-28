defmodule Balanced.APIKeys do
  alias Balanced.Base, as: Base
  alias Balanced.Http, as: Http

  @endpoint "api_keys"

  def get(id), do: Base.get(@endpoint, id)

  def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

  def delete(id), do: Base.delete(@endpoint, id)

  def create(), do: Http.post(@endpoint)

end