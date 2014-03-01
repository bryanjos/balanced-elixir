defmodule Balanced do
	@moduledoc """
	This module defines the balanced API. Use it as follows

	defmodule MyModule do
		use Balanced, secret_key: "secret_key", marketplace_id: "marketplace_id"

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
		secret_key = Keyword.fetch!(opts, :secret_key)
		marketplace_id = Keyword.fetch!(opts, :marketplace_id)

		quote do

			defmodule Http do
  				alias HTTPotion.Response

  				@basic_auth :base64.encode_to_string("#{unquote(secret_key)}:")
  				@headers [ "Authorization": "Basic #{@basic_auth}"]
  				@form_header  ["Content-Type": "application/x-www-form-urlencoded"] 
				@url "https://api.balancedpayments.com/v1/"
				@options [timeout: 7000]

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
			      	if response.success? do
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

			defmodule BankAccounts do
				@marketplace_id unquote(marketplace_id) 

				def get(bank_account_id) do
					Http.get("bank_accounts/#{bank_account_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "bank_accounts"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = "bank_accounts?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = "bank_accounts?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def create(name, account_number, routing_number, account_type \\ nil, type \\ nil, meta \\ nil) do
					body = [
						name: name, account_number: account_number, routing_number: routing_number
					]

					if account_type != nil, do: body = Dict.put(body, :account_type, account_type)
					if type != nil, do: body = Dict.put(body, :type, type)
					if meta != nil, do: body = Dict.put(body, :meta, meta)

					Http.post("marketplaces/#{@marketplace_id}/bank_accounts", body)
				end

				def delete(bank_account_id) do
					Http.delete("bank_accounts/#{bank_account_id}")
				end

				def credit(bank_account_id, amount) do
					Http.post("bank_accounts/#{bank_account_id}/credits", [amount: amount])
				end

				def credits(bank_account_id, limit \\ 0, offset \\ 0) do
					endpoint = "bank_accounts/#{bank_account_id}/credits"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint =  endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				defmodule Verifications do

					def get(bank_account_id, verification_id) do
						Http.get("bank_accounts/#{bank_account_id}/verifications/#{verification_id}")
					end

					def create(bank_account_id) do
						Http.post("bank_accounts/#{bank_account_id}/verifications")
					end

					def confirm(bank_account_id, verification_id, amount_1, amount_2) do
						body = [ amount_1: amount_1, amount_2: amount_2]
						Http.put("bank_accounts/#{bank_account_id}/verifications/#{verification_id}", body)
					end
				end
			end

			defmodule Cards do
				@marketplace_id unquote(marketplace_id) 

				def tokenize(card_number, expiration_year, expiration_month, 
					security_code \\ nil, name \\ nil, phone_number \\ nil, city \\ nil, 
					region \\ nil, state \\ nil, postal_code \\ nil, street_address \\ nil, 
					country_code \\ nil, meta \\ nil, verify \\ nil) do

					body = [
						card_number: card_number, expiration_year: expiration_year, expiration_month: expiration_month
					]

					if security_code != nil, do: body = Dict.put(body, :security_code, security_code)
					if name != nil, do: body = Dict.put(body, :name, name)
					if phone_number != nil, do: body = Dict.put(body, :phone_number, phone_number)
					if city != nil, do: body = Dict.put(body, :city, city)
					if region != nil, do: body = Dict.put(body, :region, region)
					if state != nil, do: body = Dict.put(body, :state, state)
					if postal_code != nil, do: body = Dict.put(body, :postal_code, postal_code)
					if street_address != nil, do: body = Dict.put(body, :street_address, street_address)
					if country_code != nil, do: body = Dict.put(body, :country_code, country_code)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if verify != nil, do: body = Dict.put(body, :verify, verify)

					Http.post("marketplaces/#{@marketplace_id}/cards", body)
				end

				def get(card_id) do
					Http.get("marketplaces/#{@marketplace_id}/cards/#{card_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "marketplaces/#{@marketplace_id}/cards"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def update(card_id, name \\ nil, phone_number \\ nil, city \\ nil, 
					region \\ nil, state \\ nil, postal_code \\ nil, street_address \\ nil, 
					country_code \\ nil, meta \\ nil, verify \\ nil) do

					body = []

					if name != nil, do: body = Dict.put(body, :name, name)
					if phone_number != nil, do: body = Dict.put(body, :phone_number, phone_number)
					if city != nil, do: body = Dict.put(body, :city, city)
					if region != nil, do: body = Dict.put(body, :region, region)
					if state != nil, do: body = Dict.put(body, :state, state)
					if postal_code != nil, do: body = Dict.put(body, :postal_code, postal_code)
					if street_address != nil, do: body = Dict.put(body, :street_address, street_address)
					if country_code != nil, do: body = Dict.put(body, :country_code, country_code)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if verify != nil, do: body = Dict.put(body, :verify, verify)

					Http.put("marketplaces/#{@marketplace_id}/cards/#{card_id}", body)
				end

				def invalidate(card_id) do
					Http.put("marketplaces/#{@marketplace_id}/cards/#{card_id}", [is_valid: false])
				end

				def delete(card_id) do
					Http.delete("marketplaces/#{@marketplace_id}/cards/#{card_id}")
				end

			end

			defmodule Credits do
				def get(credit_id) do
					Http.get("credits/#{credit_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "credits"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end
			end

			defmodule Customers do
				def get(customer_id) do
					Http.get("customers/#{customer_id}")
				end

				def create(name \\ nil, email \\ nil, meta \\ nil, 
					ssn_last4 \\ nil, business_name \\ nil, address_line1 \\ nil, 
					address_line2 \\ nil, address_city \\ nil, address_state \\ nil, 
					address_postal_code \\ nil, address_country_code \\ nil, 
					phone \\ nil, dob \\ nil, ein \\ nil, facebook \\ nil, twitter \\ nil) do

					body = []

					if name != nil, do: body = Dict.put(body, :name, name)
					if email != nil, do: body = Dict.put(body, :email, email)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if ssn_last4 != nil, do: body = Dict.put(body, :ssn_last4, ssn_last4)
					if phone != nil, do: body = Dict.put(body, :phone, phone)
					if dob != nil, do: body = Dict.put(body, :dob, dob)
					if ein != nil, do: body = Dict.put(body, :ein, ein)
					if facebook != nil, do: body = Dict.put(body, :facebook, facebook)
					if twitter != nil, do: body = Dict.put(body, :twitter, twitter)

					if address_line1 != nil or address_line2 != nil or address_city != nil or address_state != nil or
					address_postal_code != nil or address_country_code != nil do
						address = []

						if address_line1 != nil, do: address = Dict.put(address, :line1, address_line1)
						if address_line2 != nil, do: address = Dict.put(address, :line2, address_line2)
						if address_city != nil, do: address = Dict.put(address, :city, address_city)
						if address_state != nil, do: address = Dict.put(address, :state, address_state)
						if address_postal_code != nil, do: address = Dict.put(address, :postal_code, address_postal_code)
						if address_country_code != nil, do: address = Dict.put(address, :country_code, address_country_code)

						body = Dict.put(body, :address, address)
					end

					Http.post("customers", body)
				end

				def add_card(customer_id, card_uri) do
					Http.put("customers/#{customer_id}", [card_uri: card_uri])
				end

				def add_bank_account(customer_id, bank_account_uri) do
					Http.put("customers/#{customer_id}", [bank_account_uri: bank_account_uri])
				end

				def credits(customer_id, limit \\ 0, offset \\ 0) do
					endpoint = "customers/#{customer_id}/credits"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint =  endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def debit(customer_id, amount \\ nil, on_behalf_of_uri \\ nil, 
					appears_on_statement_as \\ nil, meta \\ nil, description \\ nil, 
					account_uri \\ nil, customer_uri \\ nil, hold_uri \\ nil, source_uri \\ nil) do

					body = []

					if on_behalf_of_uri != nil, do: body = Dict.put(body, :on_behalf_of_uri, on_behalf_of_uri)
					if amount != nil, do: body = Dict.put(body, :amount, amount)
					if appears_on_statement_as != nil, do: body = Dict.put(body, :appears_on_statement_as, appears_on_statement_as)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if description != nil, do: body = Dict.put(body, :description, description)
					if account_uri != nil, do: body = Dict.put(body, :account_uri, account_uri)
					if customer_uri != nil, do: body = Dict.put(body, :customer_uri, customer_uri)
					if hold_uri != nil, do: body = Dict.put(body, :hold_uri, hold_uri)
					if source_uri != nil, do: body = Dict.put(body, :source_uri, source_uri)

					Http.post("customers/#{customer_id}/debits", body)
				end

				def debits(customer_id, limit \\ 0, offset \\ 0) do
					endpoint = "customers/#{customer_id}/debits"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def holds(customer_id, limit \\ 0, offset \\ 0) do
					endpoint = "customers/#{customer_id}/holds"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def delete(customer_id) do
					Http.delete("customers/#{customer_id}")
				end
			end

			defmodule Debits do
				@marketplace_id unquote(marketplace_id) 

				def get(debit_id) do
					Http.get("marketplaces/#{@marketplace_id}/debits/#{debit_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "marketplaces/#{@marketplace_id}/debits"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def update(debit_id, meta \\ nil, description \\ nil) do

					body = []

					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if description != nil, do: body = Dict.put(body, :description, description)

					Http.put("marketplaces/#{@marketplace_id}/debits/#{debit_id}", body)
				end

				def refund(debit_id) do
					Http.post("marketplaces/#{@marketplace_id}/debits/#{debit_id}/refunds")
				end
			end

			defmodule Events do
				def get(event_id) do
					Http.get("events/#{event_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "events"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end
			end

			defmodule Holds do
				@marketplace_id unquote(marketplace_id) 

				def create(amount, account_uri \\ nil, appears_on_statement_as \\ nil, 
					description \\ nil, meta \\ nil, source_uri \\ nil, card_uri \\ nil) do

					body = [amount: amount]

					if account_uri != nil, do: body = Dict.put(body, :account_uri, account_uri)
					if appears_on_statement_as != nil, do: body = Dict.put(body, :appears_on_statement_as, appears_on_statement_as)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if description != nil, do: body = Dict.put(body, :description, description)
					if card_uri != nil, do: body = Dict.put(body, :account_uri, card_uri)
					if source_uri != nil, do: body = Dict.put(body, :source_uri, source_uri)

					Http.post("marketplaces/#{@marketplace_id}/holds", body)
				end

				def get(hold_id) do
					Http.get("marketplaces/#{@marketplace_id}/holds/#{hold_id}")
				end

				def list(limit \\ 0, offset \\ 0) do
					endpoint = "marketplaces/#{@marketplace_id}/holds"

					cond do
						limit > 0 and offset <= 0 ->
							endpoint = endpoint <> "?limit=#{limit}"
						limit > 0 and offset > 0 ->
							endpoint = endpoint <> "?limit=#{limit}&offset=#{offset}"
						true ->
							endpoint							
					end

					Http.get(endpoint)
				end

				def update(hold_id, on_behalf_of_uri \\ nil, meta \\ nil, description \\ nil) do

					body = []

					if on_behalf_of_uri != nil, do: body = Dict.put(body, :on_behalf_of_uri, on_behalf_of_uri)
					if meta != nil, do: body = Dict.put(body, :meta, meta)
					if description != nil, do: body = Dict.put(body, :description, description)

					Http.put("marketplaces/#{@marketplace_id}/holds/#{hold_id}", body)
				end

				def void(hold_id) do
					Http.put("marketplaces/#{@marketplace_id}/holds/#{hold_id}", [is_void: true])
				end
			end
		end
	end
end
