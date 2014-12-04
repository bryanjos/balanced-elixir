defmodule Balanced.API do
  
  defmacro __using__(_) do
    quote do
      alias Balanced.Base, as: Base
      alias Balanced.Http, as: Http
    end
  end

end