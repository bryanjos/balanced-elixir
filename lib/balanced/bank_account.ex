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

  defstruct created_at: nil, 
            href: nil, 
            id: nil, 
            links: %{}, 
            meta: %{}, 
            updated_at: nil,
            account_number: nil,
            account_type: nil,
            address: %Balanced.Address{},
            bank_name: nil,
            can_credit: nil,
            can_debit: nil,
            fingerprint: nil,
            name: nil,
            routing_number: nil
end