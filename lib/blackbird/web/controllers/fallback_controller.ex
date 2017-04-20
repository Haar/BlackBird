defmodule Blackbird.Web.FallbackController do
  use Blackbird.Web, :controller

  require Logger

  def call(conn, {:error, :validation, errors}) do
    conn
    |> put_status(400)
    |> json(%{errors: errors})
  end

  def call(conn, {:error, scope, message}) do
    conn
    |> log(scope, message)
    |> put_status(500)
    |> json(%{error: "An error has occurred."})
  end

  defp log(conn, scope, message) do
    Logger.warn("An error occurred! Scope: #{scope} - #{message}")

    conn
  end
end
