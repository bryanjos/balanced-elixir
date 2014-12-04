#TODO: Use Timex for dates
defmodule Balanced.APIKey do
  @type t :: %Balanced.APIKey{
    created_at: binary, 
    href: binary, 
    id: binary, 
    links: map,
    meta: map, 
    secret: binary
  }

  defstruct created_at: nil, 
            href: nil, 
            id: nil, 
            links: %{},
            meta: %{}, 
            secret: nil
end