defmodule Balanced.API.APIKeys do
  use Balanced.API
  
  @endpoint "api_keys"

  @doc """
  Creates a new API Key
  """
  @spec create(pid) :: Balanced.response
  def create(balanced) do 
    Http.post(balanced, @endpoint)
  end

  @doc """
  Get an existing API key.  
  """
  @spec get(pid, binary) :: Balanced.response
  def get(balanced, id) do 
    Base.get(balanced, @endpoint, id)
  end

  @doc """
  List all API keys for the marketplace. 
  """
  @spec list(pid, number, number) :: Balanced.response
  def list(balanced, limit \\ 0, offset \\ 0) do 
    Base.list(balanced, @endpoint, limit, offset)
  end

  @doc """
  Delete an API key.  
  """
  @spec delete(pid, binary) :: Balanced.response
  def delete(balanced, id) do
    Base.delete(balanced, @endpoint, id)
  end

end