defmodule Balanced.API.Callbacks do
  use Balanced.API

  @type method :: :get | :post | :put
  
  @endpoint "callbacks"

  @doc """
  Creates a callback to which events are sent.
  """
  @spec create(pid, binary, method) :: Balanced.response
  def create(balanced, url, method) do
    Http.post(balanced, @endpoint, %{ url: url, method: Atom.to_string(method) })
    |> Balanced.API.to_response(Balanced.Callback, String.to_atom(@endpoint))
  end

  @doc """
  Gets the specified callback
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do
    Base.get(balanced, @endpoint, id)
    |> Balanced.API.to_response(Balanced.Callback, String.to_atom(@endpoint))
  end

  @doc """
  Lists callbacks
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do
    Base.list(balanced, @endpoint, limit, offset)
    |> Balanced.API.to_response(Balanced.Callback, String.to_atom(@endpoint))
  end

  @doc """
  Deletes the specified callback
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

end