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

  defstruct created_at: nil, 
            href: nil, 
            id: nil, 
            links: %{}, 
            meta: %{}, 
            updated_at: nil,
            attempts: nil,
            attempts_remaining: nil,
            deposit_status: nil,
            verification_status: nil
end