defmodule Balanced.API do
  
  defmacro __using__(_) do
    quote do
      alias Balanced.API.Base, as: Base
      alias Balanced.API.Http, as: Http
    end
  end

  def to_response({:ok, response}, struct, collection_name) do
    items = Enum.map(response[collection_name], fn(x) -> struct(struct, x) end)
    { :ok, Map.new() |> Map.put(collection_name, items) |> Map.put(:links, response[:links]) }
  end

  def to_response({:error, response}, _, _) do
    items = Enum.map(response[:errors], fn(x) -> struct(Balanced.Error, x) end)
    { :error, %{errors: items, links: response[:links]} }
  end

end