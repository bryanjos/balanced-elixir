defmodule Balanced.API.Http do
  use Mix.Config
  alias HTTPotion.Response
  require Logger

  @form_header  ["Content-Type": "application/x-www-form-urlencoded"]
  @url "https://api.balancedpayments.com/"

  def get(balanced, endpoint) do
      headers = get_headers(balanced)
      HTTPotion.get(@url <> endpoint, headers) 
      |> handle_response
    end

  def post(balanced, endpoint, body \\ []) do
      headers = get_headers(balanced) |> Enum.concat(@form_header)
      HTTPotion.post(@url <> endpoint, encode_params(body), headers) 
      |> handle_response
    end

  def put(balanced, endpoint, body \\ []) do
      headers = get_headers(balanced) |> Enum.concat(@form_header)
      HTTPotion.put(@url <> endpoint, encode_params(body), headers) 
      |> handle_response
    end

  def delete(balanced, endpoint) do
      headers = get_headers(balanced)
      HTTPotion.delete(@url <> endpoint, headers) 
      |> handle_response
    end

    defp handle_response(response) do
      data = if response.body == "", do: "{}", else: response.body
      |> Poison.decode!(keys: :atoms)

      if Response.success?(response) do
        {:ok, data}
      else
        {:error, data}
      end
    end

    def encode_params(params) do
      encode_params(params, "")
    end

    def encode_params(params, header) when is_list(params) do
      params
      |> Enum.map(&get_param_string(&1, header))
      |> Enum.join("&")
    end

    def encode_params(params, header) when is_map(params) do
      Map.from_struct(params)
      |> Map.to_list
      |> encode_params(header)
      |> String.replace("[nil]&","")
      |> String.replace("&[nil]","")
    end

    def get_param_string(kv, header) do
      {key, value} = kv
      cond do
        value == nil ->
          "[nil]"
        is_map(value) ->
          Map.from_struct(value)
          |> Map.to_list
          |> encode_params(key)
        !is_list(value) and header == "" ->
          "#{key}=#{value}"
        !is_list(value) and header != "" ->
          "#{header}[#{key}]=#{value}"
        true ->
          encode_params(value, key)
      end
    end

    defp get_headers(balanced) do
      secret_key = Balanced.secret_key(balanced)
      basic_auth = :base64.encode_to_string("#{secret_key}:")
      [ "Authorization": "Basic #{basic_auth}", "Accept": "application/vnd.api+json;revision=1.1" ]
    end
end