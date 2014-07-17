defmodule Balanced do
	@moduledoc """
	This module defines the balanced API. Use it as follows

	defmodule MyModule do

		use Balanced, secret_key: "secret_key"

		def get_bank_account(bank_account_id) do

			BankAccounts.get(bank_account_id)

		end
	end

	All calls to any functions will return either:

		* {:ok, response} - Success

		* {:error, response} - Error

	Where response and error are Dicts returned from Balanced.
	Info about the contents can be found at https://docs.balancedpayments.com/1.0/api/
	"""
	defmacro __using__(opts) do
		secret_key = Keyword.get(opts, :secret_key)
		timeout = Keyword.get(opts, :timeout, 7000)

		quote do

			defmodule Http do
  				alias HTTPotion.Response

  				@basic_auth :base64.encode_to_string("#{unquote(secret_key)}:")
  				@headers [ "Authorization": "Basic #{@basic_auth}", "Accept": "application/vnd.api+json;revision=1.1"]
  				@form_header  ["Content-Type": "application/x-www-form-urlencoded"]
					@url "https://api.balancedpayments.com/"
					@options [timeout: unquote(timeout)]

				def get(endpoint) do
				    HTTPotion.get(@url <> endpoint, @headers, options: @options) |> handle_response
			  	end

				def post(endpoint, body \\ []) do
				    HTTPotion.post(@url <> endpoint, dict_to_params(body), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
			  	end

				def put(endpoint, body \\ []) do
				    HTTPotion.put(@url <> endpoint, dict_to_params(body), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
			  	end

				def delete(endpoint) do
				    HTTPotion.delete(@url <> endpoint, @headers, options: @options) |> handle_response
			  	end

			  	defp handle_response(response) do
				   	{_, json_decoded} = JSON.decode(response.body)
			      	if Response.success?(response) do
				      	{ :ok, json_decoded}
			      	else
				        { :error, json_decoded}
			    	end
			  	end

			  	def dict_to_params(params_dict, header \\ "") do
			  		Enum.map(params_dict, &get_param_string(&1, header))
			  		|> Enum.join("&")
			  	end

			  	def get_param_string(kv, header \\ "") do
			  		{key, value} = kv
			  		cond do
			  			!is_list(value) and header == "" ->
			  				"#{key}=#{value}"
			  			!is_list(value) and header != "" ->
			  				"#{header}[#{key}]=#{value}"
			  			true ->
			  				dict_to_params(value, key)
			  		end
			  	end
			end

			defmodule Base do
				def get(endpoint, id), do: Http.get("#{endpoint}/#{id}")
				def delete(endpoint, id), do: Http.delete("#{endpoint}/#{id}")

				def list(endpoint, limit \\ 0, offset \\ 0) do
					ep = endpoint

					if limit > 0 do
						ep <> "?limit=#{limit}"

						if offset > 0 do
							ep <> "&offset=#{offset}"
						end
					end

					Http.get(ep)
				end

				def add_to_body(body, key, value) do
					case value do
						nil ->
							body
						_ ->
							Dict.put(body, key, value)
					end
				end
			end

			defmodule APIKeys do
				@endpoint "api_keys"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
				def delete(id), do: Base.delete(@endpoint, id)
				def create(), do: Http.post(@endpoint)
			end

			defmodule BankAccounts do
				@endpoint "bank_accounts"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
				def delete(id), do: Base.delete(@endpoint, id)

				def create(name, account_number, routing_number, account_type, address_country_code \\ nil) do
					body = [
						name: name, account_number: account_number, routing_number: routing_number, account_type: account_type
					]

					if address_country_code != nil, do: body = Dict.put(body, :address, [country_code: address_country_code])

					Http.post(@endpoint, body)
				end

				def update(id, meta \\ nil, links \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:links, links)

					Http.put(@endpoint, body)
				end

				def debit(id, appears_on_statement_as \\ nil, source \\ nil, amount \\ nil, order \\ nil) do
					body = []
					|> Base.add_to_body(:appears_on_statement_as, appears_on_statement_as)
					|> Base.add_to_body(:source, source)
					|> Base.add_to_body(:amount, amount)
					|> Base.add_to_body(:order, order)

					Http.post("#{@endpoint}/#{id}/debits", body)
				end

				def credit(id, amount, description \\ nil, order \\ nil) do
					body = [amount: amount]
					|> Base.add_to_body(:description, description)
					|> Base.add_to_body(:order, order)

					Http.post("#{@endpoint}/#{id}/credits", body)
				end

				def credits(id, limit \\ 0, offset \\ 0), do: Base.list("#{@endpoint}/#{id}/credits", limit, offset)
			end

			defmodule BankAccountVerifications do
				@endpoint "verifications"

				def get(id), do: Base.get(@endpoint, id)

				def create(bank_account_id), do: Http.post("bank_accounts/#{bank_account_id}/#{@endpoint}")

				def confirm(id, amount_1, amount_2) do
					Http.put("#{@endpoint}/#{id}", [ amount_1: amount_1, amount_2: amount_2])
				end
			end

			defmodule Callbacks do
				@endpoint "callbacks"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
				def delete(id), do: Base.delete(@endpoint, id)
				def create(url), do: Http.post(@endpoint, [url: url])
			end

			defmodule Cards do
				@endpoint "cards"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
				def delete(id), do: Base.delete(@endpoint, id)

				def create(number, expiration_year, expiration_month,
					cvv \\ nil, name \\ nil, address_line1 \\ nil,
					address_line2 \\ nil, address_city \\ nil, address_state \\ nil,
					address_postal_code \\ nil, address_country_code \\ nil) do

					body = [number: number, expiration_year: expiration_year, expiration_month: expiration_month]
					|> Base.add_to_body(:cvv, cvv)
					|> Base.add_to_body(:name, name)

					if address_line1 != nil or address_line2 != nil or address_city != nil or address_state != nil or
					address_postal_code != nil or address_country_code != nil do

						address = []
						|> Base.add_to_body(:line1, address_line1)
						|> Base.add_to_body(:line2, address_line2)
						|> Base.add_to_body(:city, address_city)
						|> Base.add_to_body(:state, address_state)
						|> Base.add_to_body(:postal_code, address_postal_code)
						|> Base.add_to_body(:country_code, address_country_code)

						body = Dict.put(body, :address, address)
					end

					Http.post(@endpoint, body)
				end

				def update(id, meta \\ nil, links \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:links, links)

					Http.put("#{@endpoint}/#{id}", body)
				end

				def debit(id, amount, appears_on_statement_as \\ nil, source \\ nil, order \\ nil) do
					body = [amount: amount]
					|> Base.add_to_body(:appears_on_statement_as, appears_on_statement_as)
					|> Base.add_to_body(:source, source)
					|> Base.add_to_body(:order, order)

					Http.post("#{@endpoint}/#{id}/debits", body)
				end
			end

			defmodule CardHolds do
				@endpoint "card_holds"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(card_id, amount) do
					Http.post("cards/#{card_id}/#{@endpoint}", [amount: amount])
				end

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.put("#{@endpoint}/#{id}", body)
				end

				def debit(id, appears_on_statement_as \\ nil, source \\ nil, amount \\ nil, order \\ nil) do
					body = []
					|> Base.add_to_body(:appears_on_statement_as, appears_on_statement_as)
					|> Base.add_to_body(:source, source)
					|> Base.add_to_body(:amount, amount)
					|> Base.add_to_body(:order, order)

					Http.post("#{@endpoint}/#{id}/debits", body)
				end

				def void(id), do: Http.put("#{@endpoint}/#{id}", [is_void: true])
			end

			defmodule Credits do
				@endpoint "credits"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.post("#{@endpoint}/#{id}", body)
				end
			end

			defmodule Customers do
				@endpoint "customers"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
				def delete(id), do: Base.delete(@endpoint, id)

				def create(name \\ nil, email \\ nil, meta \\ nil,
					ssn_last4 \\ nil, business_name \\ nil, address_line1 \\ nil,
					address_line2 \\ nil, address_city \\ nil, address_state \\ nil,
					address_postal_code \\ nil, address_country_code \\ nil,
					phone \\ nil, dob_month \\ nil, dob_year \\ nil, ein \\ nil, source \\ nil) do

					body = []
					|> Base.add_to_body(:name, name)
					|> Base.add_to_body(:email, email)
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:ssn_last4, ssn_last4)
					|> Base.add_to_body(:phone, phone)
					|> Base.add_to_body(:dob_month, dob_month)
					|> Base.add_to_body(:dob_year, dob_year)
					|> Base.add_to_body(:ein, ein)
					|> Base.add_to_body(:source, source)

					if address_line1 != nil or address_line2 != nil or address_city != nil or address_state != nil or
					address_postal_code != nil or address_country_code != nil do
						address = []
						|> Base.add_to_body(:line1, address_line1)
						|> Base.add_to_body(:line2, address_line2)
						|> Base.add_to_body(:city, address_city)
						|> Base.add_to_body(:state, address_state)
						|> Base.add_to_body(:postal_code, address_postal_code)
						|> Base.add_to_body(:country_code, address_country_code)

						body = Dict.put(body, :address, address)
					end

					Http.post(@endpoint, body)
				end

				def update(id, name \\ nil, email \\ nil, address_line1 \\ nil,
					address_line2 \\ nil, address_city \\ nil, address_state \\ nil,
					address_postal_code \\ nil, address_country_code \\ nil,
					dob_month \\ nil, dob_year \\ nil) do

					body = []
					|> Base.add_to_body(:name, name)
					|> Base.add_to_body(:email, email)
					|> Base.add_to_body(:dob_month, dob_month)
					|> Base.add_to_body(:dob_year, dob_year)

					if address_line1 != nil or address_line2 != nil or address_city != nil or address_state != nil or
					address_postal_code != nil or address_country_code != nil do
						address = []
						|> Base.add_to_body(:line1, address_line1)
						|> Base.add_to_body(:line2, address_line2)
						|> Base.add_to_body(:city, address_city)
						|> Base.add_to_body(:state, address_state)
						|> Base.add_to_body(:postal_code, address_postal_code)
						|> Base.add_to_body(:country_code, address_country_code)

						body = Dict.put(body, :address, address)
					end

					Http.put("#{@endpoint}/#{id}", body)
				end

				def add_card(id, card_id), do: Http.put("cards/#{card_id}", [customer: "/customers/#{id}"])
				def add_bank_account(id, bank_account_id), do: Http.put("bank_accounts/#{bank_account_id}", [customer: "/customers/#{id}"])
			end

			defmodule Debits do
				@endpoint "debits"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.put("#{@endpoint}/#{id}", body)
				end
			end

			defmodule Events do
				@endpoint "events"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)
			end

			defmodule Orders do
				@endpoint "orders"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(customer_id, address_line1 \\ nil,
					address_line2 \\ nil, address_city \\ nil, address_state \\ nil,
					address_postal_code \\ nil, address_country_code \\ nil,
					meta \\ nil, description \\ nil) do

					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					if address_line1 != nil or address_line2 != nil or address_city != nil or address_state != nil or
					address_postal_code != nil or address_country_code != nil do
						address = []
						|> Base.add_to_body(:line1, address_line1)
						|> Base.add_to_body(:line2, address_line2)
						|> Base.add_to_body(:city, address_city)
						|> Base.add_to_body(:state, address_state)
						|> Base.add_to_body(:postal_code, address_postal_code)
						|> Base.add_to_body(:country_code, address_country_code)

						body = Dict.put(body, :address, address)
					end

					Http.post("customers/#{customer_id}/#{@endpoint}", body)
				end

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.put("#{@endpoint}/#{id}", body)
				end
			end

			defmodule Refunds do
				@endpoint "refunds"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(debit_id, amount, meta \\ nil, description \\ nil) do
					body = [amount: amount]
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.post("debits/#{debit_id}/#{@endpoint}", body)
				end

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.put("#{@endpoint}/#{id}", body)
				end
			end

			defmodule Reversals do
				@endpoint "reversals"

				def get(id), do: Base.get(@endpoint, id)
				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(credit_id, amount) do
					Http.post("credits/#{credit_id}/#{@endpoint}", [amount: amount])
				end

				def update(id, meta \\ nil, description \\ nil) do
					body = []
					|> Base.add_to_body(:meta, meta)
					|> Base.add_to_body(:description, description)

					Http.put("#{@endpoint}/#{id}", body)
				end
			end
		end
	end
end
