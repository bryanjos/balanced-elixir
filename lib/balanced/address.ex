defmodule Balanced.Address do
  @type t :: %Balanced.Address{
    line1: binary, 
    line2: binary, 
    city: binary, 
    state: binary, 
    postal_code: binary, 
    country_code: binary
  }
  defstruct line1: nil, 
            line2: nil, 
            city: nil, 
            state: nil, 
            postal_code: nil, 
            country_code: nil
end