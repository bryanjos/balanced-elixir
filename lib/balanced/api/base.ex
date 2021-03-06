defmodule Balanced.API.Base do
  alias Balanced.API.Http

  @moduledoc false

  def get(balanced, endpoint, id, struct, collection_name) do 
    Http.get(balanced, "#{endpoint}/#{id}")
    |> to_response(struct, collection_name)
  end

  def post(balanced, endpoint, data, struct, collection_name) do 
    Http.post(balanced, endpoint, data)
    |> to_response(struct, collection_name)
  end

  def post(balanced, endpoint, struct, collection_name) do 
    post(balanced, endpoint, %{}, struct, collection_name)
  end

  def put(balanced, endpoint, data, struct, collection_name) do 
    Http.put(balanced, endpoint, data)
    |> to_response(struct, collection_name)
  end

  def put(balanced, endpoint, struct, collection_name) do 
    put(balanced, endpoint, %{}, struct, collection_name)
  end

  def delete(balanced, endpoint, id, struct, collection_name) do
    Http.delete(balanced, "#{endpoint}/#{id}")
    |> to_response(struct, collection_name)
  end

  def list(balanced, endpoint, limit, offset, struct, collection_name) do
    Http.get(balanced, "#{endpoint}?limit=#{limit}&offset=#{offset}")
    |> to_response(struct, collection_name)
  end

  def to_response({status, ""}, _, _) do
    {status, nil}
  end

  def to_response({status, response}, struct, collection_name) do
    { status, decode_response(response, collection_name, struct) }
  end

  defp decode_response(response, collection_name, struct) do
      map_prototype = Map.new() 
      |> Map.put(collection_name, [struct]) 
      |> Map.put("links", [Map])
      |> Map.put("errors", [Balanced.Error])

      Poison.decode!(response, keys: :atoms, as: map_prototype)
  end

end