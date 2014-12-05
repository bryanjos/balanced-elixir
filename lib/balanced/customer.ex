defmodule Balanced.Customer do
  @type t :: %Balanced.Customer{
    created_at: binary,
    href: binary, 
    id: binary, 
    links: map, 
    meta: map, 
    updated_at: binary,
    address: Balanced.Address.t,
    business_name: binary,
    dob_month: number,
    dob_year: number,
    ein: binary,
    email: binary,
    merchant_status: binary,
    name: binary,
    phone: binary,
    ssn_last4: binary
  }

    defstruct [
        :created_at,
        :href, 
        :id, 
        :links, 
        :meta, 
        :updated_at,
        :address,
        :business_name,
        :dob_month,
        :dob_year,
        :ein,
        :email,
        :merchant_status,
        :name,
        :phone,
        :ssn_last4
    ]
end