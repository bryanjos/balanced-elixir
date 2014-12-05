defmodule Balanced.Credit do
  @type t :: %Balanced.Credit{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    amount: number,
    currency: binary,
    description: binary,
    appears_on_statement_as: binary,
    failure_reason: binary,
    failure_reason_code: binary,
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
        :appears_on_statement_as,
        :failure_reason,
        :failure_reason_code,
        :status,
        :transaction_number
    ] 
end