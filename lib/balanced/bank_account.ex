defmodule Balanced.BankAccount do
    @type t :: %Balanced.BankAccount{
        created_at: binary,
        href: binary, 
        id: binary, 
        links: map, 
        meta: map, 
        updated_at: binary,
        account_number: binary,
        account_type: binary,
        address: Balanced.Address.t,
        bank_name: binary,
        can_credit: boolean,
        can_debit: boolean,
        fingerprint: binary,
        name: binary,
        routing_number: binary
    }

    defstruct [
        :created_at,
        :href,
        :id,
        :links ,
        :meta,
        :updated_at,
        :account_number,
        :account_type,
        :address,
        :bank_name,
        :can_credit,
        :can_debit,
        :fingerprint,
        :name,
        :routing_number
    ]
end