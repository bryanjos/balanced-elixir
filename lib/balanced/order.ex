defmodule Balanced.Order do
  @type t :: %Balanced.Order{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    amount: number,
    amount_escrowed: number,
    currency: binary,
    description: binary,
    delivery_address: Balanced.Address.t
  }

    defstruct [
        :created_at, 
        :href, 
        :id, 
        :links, 
        :meta, 
        :updated_at,
        :amount,
        :amount_escrowed,
        :currency,
        :description,
        :delivery_address
    ]
end