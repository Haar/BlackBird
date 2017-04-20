defmodule HTTP do
  alias HTTP.Logger

  # @cacertfile_path Application.app_dir(:blackbird, "priv/NEW-BSKYB-ISSUING-CA01.crt")
  @cacertfile_path System.get_env("CA_CERT_FILE_PATH")

  defmodule Error do
    defstruct [reason: nil]
  end

  defmodule Request do
    defstruct [url: nil, headers: [], body: nil]
  end

  defmodule Response do
    defstruct [body: nil, headers: [], status_code: nil]
  end

  def get(service, %{url: url, headers: headers} = request, opts \\ []) do
    start_time = Logger.log_request(service, :get, request)

    HTTPoison.get(url, headers, Keyword.merge(ssl_options(), opts))
    |> Logger.log_response(start_time)
    |> decode
  end

  def post(service, %{url: url, body: body, headers: headers} = request, opts \\ []) do
    start_time = Logger.log_request(service, :post, request)

    HTTPoison.post(url, body, headers, Keyword.merge(ssl_options(), opts))
    |> Logger.log_response(start_time)
    |> decode
  end

  def put(service, %{url: url, body: body, headers: headers} = request, opts \\ []) do
    start_time = Logger.log_request(service, :put, request)

    HTTPoison.put(url, body, headers, Keyword.merge(ssl_options(), opts))
    |> Logger.log_response(start_time)
    |> decode
  end

  defp decode({:ok, %{body: body} = response}) do
    decoded_body = case Poison.decode(body) do
                    {:ok, decoded} -> decoded
                    _              -> body
                  end
    response
    |> Map.put(:body, decoded_body)
    |> Map.from_struct
    |> (&{:ok, struct(Response, &1)}).()
  end
  defp decode({:error, error}), do: {:error, struct(Error, Map.from_struct(error))}

  defp ssl_options do
    [ssl: [cacertfile: @cacertfile_path]]
  end
end
