defmodule Balanced.Base do

  def get(endpoint, id), do: Balanced.Http.get("#{endpoint}/#{id}")

  def delete(endpoint, id), do: Balanced.Http.delete("#{endpoint}/#{id}")

  def list(endpoint, limit \\ 0, offset \\ 0) do
    ep = endpoint

    if limit > 0 do
      ep <> "?limit=#{limit}"

      if offset > 0 do
        ep <> "&offset=#{offset}"
      end
    end

    Balanced.Http.get(ep)
  end

end