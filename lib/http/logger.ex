defmodule HTTP.Logger do
  alias HTTP.Request
  require Logger

  def log_request(service_name, http_method, %Request{url: url, body: body}) do
    request_md = [http_method: http_method, url: url, service: service_name]

    Logger.debug ("Making #{http_method} request to [#{url}] of #{service_name}" <>
                  "#{body && " with body: #{body}" }"), request_md

    timestamp()
  end

  def log_response({:ok, %{body: body}} = response, start_time) do
    response_md = [http_duration: timestamp() - start_time]
    Logger.debug "Response completed successfully with body: #{body}", response_md

    response
  end

  def log_response({:error, error} = response, start_time) do
    response_md = [http_duration: timestamp() - start_time]
    Logger.error "Response failed with error: #{error.reason}", response_md

    response
  end

  defp timestamp do
    :os.system_time(:milli_seconds)
  end
end
