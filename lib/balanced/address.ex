defmodule Balanced.Address do
  @type t :: %Balanced.Address{
    line1: binary, 
    line2: binary, 
    city: binary, 
    state: binary, 
    postal_code: binary, 
    country_code: binary
  }
  defstruct [
    :line1, 
    :line2, 
    :city, 
    :state, 
    :postal_code, 
    :country_code
  ]
end