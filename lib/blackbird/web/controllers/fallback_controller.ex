defmodule Blackbird.Web.FallbackController do
  use Blackbird.Web, :controller

  def call(conn, {:error, :validation, errors}) do
    conn
    |> put_status(400)
    |> json(%{errors: errors})
  end

  def call(conn, {:error, scope, message}) do
    conn
    |> put_status(500)
    |> log(scope, message)
    |> json(%{error: "An error has occurred."})
  end

  defp log(conn, scope, message) do
    IO.puts("status: #{conn.status}")
    IO.puts("scope: #{scope}")
    IO.puts("message: #{message}")

    conn
  end
end
