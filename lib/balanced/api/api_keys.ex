defmodule Balanced.API.APIKeys do
  alias Balanced.API.Base
  
  @endpoint "api_keys"
  @data_struct Balanced.APIKey
  @collection_name String.to_atom(@endpoint)

  @doc """
  Creates a new API Key
  """
  @spec create(pid) :: Balanced.response
  def create(balanced) do 
    Base.post(balanced, @endpoint, @data_struct, @collection_name)
  end

  @doc """
  Get an existing API key.  
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  List all API keys for the marketplace. 
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 10, offset \\ 0) do 
    Base.list(balanced, @endpoint, limit, offset, @data_struct, @collection_name)
  end

  @doc """
  Delete an API key.  
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id, @data_struct, @collection_name)
  end

end