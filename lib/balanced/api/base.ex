defmodule Balanced.API.Base do
  alias Balanced.API.Http

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

  def to_response({:ok, response}, struct, collection_name) do
    { :ok, decode_response(response, collection_name, struct) }
  end

  def to_response({:error, response}, _, _) do
    { :error, decode_response(response, "errors", Balanced.Error) }
  end

  defp decode_response(response, collection_name, struct) do
      map_prototype = Map.new() 
      |> Map.put(collection_name, [struct]) 
      |> Map.put("links", [Map])

      Poison.decode!(response, keys: :atoms, as: map_prototype)
  end

end