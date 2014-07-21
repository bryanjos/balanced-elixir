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

	Where response and error are Maps returned from Balanced.
	Info about the contents can be found at https://docs.balancedpayments.com/1.1/api/
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
				    HTTPotion.post(@url <> endpoint, dict_to_params(body,""), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
			  	end

				def put(endpoint, body \\ []) do
				    HTTPotion.put(@url <> endpoint, dict_to_params(body,""), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
			  	end

				def delete(endpoint) do
				    HTTPotion.delete(@url <> endpoint, @headers, options: @options) |> handle_response
			  	end

			  	defp handle_response(response) do
				   	{_, json_decoded} = JSEX.decode(response.body)
			      	if Response.success?(response) do
				      	{ :ok, json_decoded}
			      	else
				        { :error, json_decoded}
			    	end
			  	end

			  	def dict_to_params(params_dict, header) when is_list(params_dict) do
						params_dict
						|> Enum.map(&get_param_string(&1, header))
			  		|> Enum.join("&")
			  	end

					def dict_to_params(params_dict, header) when is_map(params_dict) do
						Map.drop(params_dict,[:__struct__])
						|> Map.to_list
						|> Enum.map(&get_param_string(&1, header))
						|> Enum.join("&")
						|> String.replace("[nil]&","")
					end

			  	def get_param_string(kv, header) do
			  		{key, value} = kv
			  		cond do
							value == nil ->
								"[nil]"
							is_map(value) ->
								Map.drop(value,[:__struct__])
								|> Map.to_list
								|> dict_to_params(key)
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

			end

			defmodule APIKeys do
				@endpoint "api_keys"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def delete(id), do: Base.delete(@endpoint, id)

				def create(), do: Http.post(@endpoint)

			end

			defmodule Address do
				defstruct line1: nil, line2: nil, city: nil, state: nil, postal_code: nil, country_code: nil
			end

			defmodule CreateDebitRequest do
				defstruct amount: nil, appears_on_statement_as: nil, source: nil, order: nil
			end

			defmodule UpdateBankAccountRequest do
				defstruct meta: nil, links: nil
			end

			defmodule CreateBankAccountRequest do
				defstruct name: nil, account_number: nil, routing_number: nil, account_type: nil, address: %Address{}
			end

			defmodule CreditBankAccountRequest do
				defstruct amount: nil, description: nil, order: nil
			end

			defmodule BankAccounts do
				@endpoint "bank_accounts"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def delete(id), do: Base.delete(@endpoint, id)

				def create(create_bank_account_request) do
					Http.post(@endpoint, create_bank_account_request)
				end

				def update(id, update_bank_account_request) do
					Http.put(@endpoint, update_bank_account_request)
				end

				def debit(id, create_debit_request) do
					Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
				end

				def credit(id, credit_bank_account_request) do
					Http.post("#{@endpoint}/#{id}/credits", credit_bank_account_request)
				end

				def credits(id, limit \\ 0, offset \\ 0), do: Base.list("#{@endpoint}/#{id}/credits", limit, offset)

			end

			defmodule ConfirmBankAccountRequest do
				defstruct amount_1: nil, amount_2: nil
			end

			defmodule BankAccountVerifications do
				@endpoint "verifications"

				def get(id), do: Base.get(@endpoint, id)

				def create(bank_account_id), do: Http.post("bank_accounts/#{bank_account_id}/#{@endpoint}")

				def confirm(id, confirm_bank_account_request) do
					Http.put("#{@endpoint}/#{id}", confirm_bank_account_request)
				end

			end

			defmodule Callbacks do
				@endpoint "callbacks"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def delete(id), do: Base.delete(@endpoint, id)

				def create(url), do: Http.post(@endpoint, [url: url])

			end

			defmodule CreateCardRequest do
				defstruct number: nil, expiration_year: nil, expiration_month: nil, cvv: nil, name: nil, address: %Address{}
			end

			defmodule UpdateCardRequest do
				defstruct meta: nil, links: nil
			end

			defmodule Cards do
				@endpoint "cards"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def delete(id), do: Base.delete(@endpoint, id)

				def create(create_card_request) do
					Http.post(@endpoint, create_card_request)
				end

				def update(id, update_card_request) do
					Http.put("#{@endpoint}/#{id}", update_card_request)
				end

				def debit(id, create_debit_request) do
					Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
				end

			end

			defmodule UpdateResourceRequest do
				defstruct meta: nil, description: nil
			end

			defmodule CardHolds do
				@endpoint "card_holds"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(card_id, amount) do
					Http.post("cards/#{card_id}/#{@endpoint}", [amount: amount])
				end

				def update(id, update_resource_request) do
					Http.put("#{@endpoint}/#{id}", update_resource_request)
				end

				def debit(id, create_debit_request) do
					Http.post("#{@endpoint}/#{id}/debits", create_debit_request)
				end

				def void(id), do: Http.put("#{@endpoint}/#{id}", [is_void: true])

			end

			defmodule Credits do
				@endpoint "credits"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def update(id, update_resource_request) do
					Http.post("#{@endpoint}/#{id}", update_resource_request)
				end

			end

			defmodule CreateCustomerRequest do
				defstruct name: nil, email: nil, meta: nil, ssn_last4: nil, business_name: nil, address: %Address{}, phone: nil, dob_month: nil, dob_year: nil, ein: nil, source: nil
			end

			defmodule UpdateCustomerRequest do
				defstruct name: nil, email: nil, address: %Address{}, dob_month: nil, dob_year: nil
			end

			defmodule Customers do
				@endpoint "customers"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def delete(id), do: Base.delete(@endpoint, id)

				def create(create_customer_request) do
					Http.post(@endpoint, create_customer_request)
				end

				def update(id, update_customer_request) do
					Http.put("#{@endpoint}/#{id}", update_customer_request)
				end

				def add_card(id, card_id), do: Http.put("cards/#{card_id}", [customer: "/customers/#{id}"])

				def add_bank_account(id, bank_account_id), do: Http.put("bank_accounts/#{bank_account_id}", [customer: "/customers/#{id}"])

			end

			defmodule Debits do
				@endpoint "debits"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def update(id, update_resource_request) do
					Http.put("#{@endpoint}/#{id}", update_resource_request)
				end

			end

			defmodule Events do
				@endpoint "events"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

			end

			defmodule CreateOrderRequest do
				defstruct address: %Address{}, meta: nil, description: nil
			end

			defmodule Orders do
				@endpoint "orders"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(customer_id, create_order_request) do
					Http.post("customers/#{customer_id}/#{@endpoint}", create_order_request)
				end

				def update(id, update_resource_request) do
					Http.put("#{@endpoint}/#{id}", update_resource_request)
				end

			end

			defmodule CreateRefundRequest do
				defstruct amount: nil, meta: nil, description: nil
			end

			defmodule Refunds do
				@endpoint "refunds"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(debit_id, create_refund_request) do
					Http.post("debits/#{debit_id}/#{@endpoint}", create_refund_request)
				end

				def update(id, update_resource_request) do
					Http.put("#{@endpoint}/#{id}", update_resource_request)
				end

			end

			defmodule Reversals do
				@endpoint "reversals"

				def get(id), do: Base.get(@endpoint, id)

				def list(limit \\ 0, offset \\ 0), do: Base.list(@endpoint, limit, offset)

				def create(credit_id, amount) do
					Http.post("credits/#{credit_id}/#{@endpoint}", [amount: amount])
				end

				def update(id, update_resource_request) do
					Http.put("#{@endpoint}/#{id}", update_resource_request)
				end

			end
		end
	end
end
