defmodule Balanced do
	use GenServer

  @type status :: :ok | :error
  @type response :: {status, map}

	@moduledoc """
	This module defines the balanced API. Use it as follows

	#looks for an environment variable named `BALANCED_SECRET_KEY`

	{:ok, balanced} = Balanced.new

	#alternatively, you can pass in the secret key as well

	{:ok, balanced} = Balanced.new("`my_secret_key`")	

	#then pass in the balanced pid when calling functions

	{status, response} = Balanced.BankAccounts.get(balanced, `bank_account_id`)

	status is either :ok or :error

	response is a Map converted from the json response from Balanced.

	Info about the contents can be found at http://docs.balancedpayments.com/1.1/api/
	"""
	def new(secret_key) do
		start_link(%{secret_key: secret_key})
	end

	def new() do
		start_link(%{secret_key: System.get_env("BALANCED_SECRET_KEY")})
	end

	def start_link(config) do
		GenServer.start_link(__MODULE__, config)
	end

	def secret_key(balanced) do
		configuration(balanced).secret_key
	end

	def configuration(balanced) do
		GenServer.call(balanced, :get_configuration)
	end

	def init(config) do
		{:ok, config}
	end

	def handle_call(:get_configuration, _from, config) do
		{:reply, config, config}
	end
end
