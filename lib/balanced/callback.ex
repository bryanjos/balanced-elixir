defmodule Balanced.Callback do
    @type t :: %Balanced.Callback{
        href: binary, 
        id: binary, 
        links: map, 
        method: binary,
        revision: binary,
        url: binary
    }

    defstruct [
        :href,
        :id,
        :links,
        :method,
        :revision,
        :url
    ]
end