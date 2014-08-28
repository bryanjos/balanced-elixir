defmodule Balanced do
	@moduledoc """
	This module defines the balanced API. Use it as follows

	In your config file, add a balanced config options
	config :balanced, secret_key: "<your_key>", time_out: <timeout, optional, defaults to 7000>

	defmodule MyModule do

		def get_bank_account(bank_account_id) do

			Balanced.BankAccounts.get(bank_account_id)

		end
	end

	All calls to any functions will return either:

		* {:ok, response} - Success

		* {:error, response} - Error

	Where response and error are Maps returned from Balanced.
	Info about the contents can be found at http://docs.balancedpayments.com/1.1/api/
	"""

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

	defmodule ConfirmBankAccountRequest do
		defstruct amount_1: nil, amount_2: nil
	end

	defmodule CreateCardRequest do
		defstruct number: nil, expiration_year: nil, expiration_month: nil, cvv: nil, name: nil, address: %Address{}
	end

	defmodule UpdateCardRequest do
		defstruct meta: nil, links: nil
	end

	defmodule UpdateResourceRequest do
		defstruct meta: nil, description: nil
	end

	defmodule CreateCustomerRequest do
		defstruct name: nil, email: nil, meta: nil, ssn_last4: nil, business_name: nil, address: %Address{}, phone: nil, dob_month: nil, dob_year: nil, ein: nil, source: nil
	end

	defmodule UpdateCustomerRequest do
		defstruct name: nil, email: nil, address: %Address{}, dob_month: nil, dob_year: nil
	end

	defmodule CreateOrderRequest do
		defstruct address: %Address{}, meta: nil, description: nil
	end

	defmodule CreateRefundRequest do
		defstruct amount: nil, meta: nil, description: nil
	end
end
