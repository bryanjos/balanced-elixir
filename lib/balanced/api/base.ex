defmodule Balanced.API.Base do

  def get(balanced, endpoint, id) do 
    Balanced.Http.get(balanced, "#{endpoint}/#{id}")
  end

  def delete(balanced, endpoint, id) do
    Balanced.Http.delete(balanced, "#{endpoint}/#{id}")
  end

  def list(balanced, endpoint, limit \\ 0, offset \\ 0) do
    ep = endpoint

    if limit > 0 do
      ep <> "?limit=#{limit}"

      if offset > 0 do
        ep <> "&offset=#{offset}"
      end
    end

    Balanced.Http.get(balanced, ep)
  end

end