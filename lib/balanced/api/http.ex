defmodule Balanced.API.Http do
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
      case HTTPotion.Response.success?(response) do
        true ->
          {:ok, response.body}
        false ->
          {:error, response.body}         
      end
    end

    def encode_params(params) do
      encode_params(params, "")
    end

    def encode_params(params, header) when is_map(params) do
      struct_to_list(params) |> encode_params(header)
    end

    def encode_params(params, header) when is_list(params) do
      params
      |> Enum.map(&get_param_string(&1, header))
      |> Enum.filter(fn(x) -> x != nil end)
      |> Enum.join("&")
    end

    def get_param_string({_, nil}, _)do
      nil
    end

    def get_param_string({key, value}, _) when is_map(value) do
      struct_to_list(value) |> encode_params(key)
    end

    def get_param_string({key, value}, _) when is_list(value) do
      encode_params(value, key)
    end

    def get_param_string({key, value}, "") do
      "#{key}=#{value}"
    end

    def get_param_string({key, value}, header) do
      "#{header}[#{key}]=#{value}"
    end

    defp get_headers(balanced) do
      secret_key = Balanced.secret_key(balanced)
      basic_auth = :base64.encode_to_string("#{secret_key}:")
      [ "Authorization": "Basic #{basic_auth}", "Accept": "application/vnd.api+json;revision=1.1" ]
    end

    defp struct_to_list(struct) do
      Map.drop(struct, [:__struct__]) |> Map.to_list   
    end
end