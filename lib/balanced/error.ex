defmodule Balanced.Error do
  @type t :: %Balanced.Error{
    additional: binary,
    category_code: binary, 
    category_type: binary, 
    description: binary,
    extras: map,
    request_id: binary,
    status: binary,
    status_code: binary
  }

    defstruct [
        :additional,
        :category_code, 
        :category_type, 
        :description,
        :extras,
        :request_id,
        :status,
        :status_code
    ]
end