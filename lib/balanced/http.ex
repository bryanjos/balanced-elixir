defmodule Balanced.Http do
  use Mix.Config
  alias HTTPotion.Response
  require Logger

  @basic_auth :base64.encode_to_string("#{Application.get_env(:balanced, :secret_key)}:")
  @headers [ "Authorization": "Basic #{@basic_auth}", "Accept": "application/vnd.api+json;revision=1.1"]
  @form_header  ["Content-Type": "application/x-www-form-urlencoded"]
  @url "https://api.balancedpayments.com/"
  @options [timeout: Application.get_env(:balanced, :timeout, 7000)]

  def get(endpoint) do
      Logger.debug("GET: #{@url <> endpoint}")
      HTTPotion.get(@url <> endpoint, @headers, options: @options) |> handle_response
    end

  def post(endpoint, body \\ []) do
      Logger.debug("POST: #{@url <> endpoint}")
      HTTPotion.post(@url <> endpoint, dict_to_params(body,""), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
    end

  def put(endpoint, body \\ []) do
      Logger.debug("PUT: #{@url <> endpoint}")
      HTTPotion.put(@url <> endpoint, dict_to_params(body,""), Enum.concat(@headers, @form_header ), options: @options ) |> handle_response
    end

  def delete(endpoint) do
      Logger.debug("DELETE: #{@url <> endpoint}")
      HTTPotion.delete(@url <> endpoint, @headers, options: @options) |> handle_response
    end

    defp handle_response(response) do
      Logger.debug("status_code: #{response.status_code}")
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