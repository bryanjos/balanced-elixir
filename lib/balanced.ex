defmodule Balanced do
	use GenServer

  @type status :: :ok | :error
  @type response :: {status, map}

  defmodule Config do
    @type t :: %Config{ secret_key: binary }
    defstruct [:secret_key]
  end

	@moduledoc """
	This module defines the balanced API. Use it as follows

	looks for an application variable in the `:balanced` app named `:secret_key`
	or an environment variable named `BALANCED_SECRET_KEY`
	
	```
	{:ok, balanced} = Balanced.new
	```
	#alternatively, you can pass in the secret key as well

	```
	{:ok, balanced} = Balanced.new("my_secret_key")	
	```
	#then pass in the balanced pid when calling functions

	```
	{status, response} = Balanced.BankAccounts.get(balanced, bank_account_id)
	```
	status is either `:ok` or `:error`

	response is a Map converted from the json response from Balanced.

	Info about the contents can be found at [http://docs.balancedpayments.com/1.1/api/](http://docs.balancedpayments.com/1.1/api/)
	"""

	@doc """
	Creates a new Balanced process.
	"""
  @spec new(binary) :: { Balanced.status, pid }
	def new(secret_key) do
		start_link(%Config{secret_key: secret_key})
	end

	@doc """
	Creates a new Balanced process, reading the secret key from the config or from an environment variable
	"""
  @spec new() :: { Balanced.status, pid }
	def new() do
		secret_key = Application.get_env(:balanced, :secret_key, System.get_env("BALANCED_SECRET_KEY"))
		new(secret_key)
	end

	def start_link(config) do
		GenServer.start_link(__MODULE__, config)
	end

	@doc """
	Returns the secret key
	"""
  @spec secret_key(pid) :: binary
	def secret_key(balanced) do
		configuration(balanced).secret_key
	end

	@doc """
	Returns the Balanced config struct
	"""
  @spec configuration(pid) :: Balanced.Config.t
	def configuration(balanced) do
		GenServer.call(balanced, :get_configuration)
	end

	def init(config) do
		{:ok, config}
	end

	@doc false
	def handle_call(:get_configuration, _from, config) do
		{:reply, config, config}
	end
end
