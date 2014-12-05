defmodule Balanced.Event do
  @type t :: %Balanced.Event{
    href: binary, 
    id: binary, 
    links: map, 
    occured_at: binary,
    type: binary,
    entity: map
  }

    defstruct [
        :href, 
        :id, 
        :links, 
        :occured_at,
        :type,
        :entity
    ]
end