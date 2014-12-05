defmodule Balanced.CardHold do
  @type t :: %Balanced.CardHold{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    amount: number,
    currency: binary,
    description: binary,
    expires_at: binary,
    failure_reason: binary,
    failure_reason_code: binary,
    status: binary,
    transaction_number: binary,
    voided_at: binary
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
        :expires_at,
        :failure_reason,
        :failure_reason_code,
        :status,
        :transaction_number,
        :voided_at
    ]
end