defmodule Balanced.Dispute do
  @type t :: %Balanced.Dispute{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    amount: number,
    currency: binary,
    initiated_at: binary,
    reason: binary,
    respond_by: binary,
    status: binary
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
        :initiated_at,
        :reason,
        :respond_by,
        :status
    ]
end