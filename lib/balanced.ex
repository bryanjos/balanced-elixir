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
		secret_key = Keyword.fetch!(opts, :secret_key)

		quote do

			defmodule Http do
  				alias HTTPotion.Response

  				@basic_auth :base64.encode_to_string("#{unquote(secret_key)}:")
  				@headers [ "Authorization": "Basic #{@basic_auth}", "Accept": "application/vnd.api+json;revision=1.1"]
  				@form_header  ["Content-Type": "application/x-www-form-urlencoded"] 
				@url "https://api.balancedpayments.com/"
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
		end
	end
end
