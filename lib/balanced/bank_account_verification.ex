defmodule Balanced.BankAccountVerification do
    @type t :: %Balanced.BankAccountVerification{
        created_at: binary,
        href: binary, 
        id: binary, 
        links: map, 
        meta: map, 
        updated_at: binary,
        attempts: number,
        attempts_remaining: binary,
        deposit_status: binary,
        verification_status: binary
    }

    defstruct [
        :created_at,
        :href,
        :id,
        :links,
        :meta,
        :updated_at,
        :attempts,
        :attempts_remaining,
        :deposit_status,
        :verification_status
    ]
end