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

  defstruct [
    :created_at, 
    :href, 
    :id, 
    :links,
    :meta, 
    :secret
  ]
end