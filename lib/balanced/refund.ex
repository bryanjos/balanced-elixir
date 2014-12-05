defmodule Balanced.Refund do
  @type t :: %Balanced.Refund{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    amount: number,
    currency: binary,
    description: binary,
    status: binary,
    transaction_number: binary
  }

    defstruct [
        :created_at, 
        :href, 
        :id, 
        :links, 
        :meta, 
        :updated_at,
        :amount,
        :currency,
        :description,
        :status,
        :transaction_number
    ]
end