defmodule Blackbird.Web.TweetsController do
  alias Blackbird.Query
  alias Blackbird.Query.Request

  use Blackbird.Web, :controller

  action_fallback Blackbird.Web.FallbackController

  def search(conn, params) do
    with {:ok, request} <- Request.build(params),
         {:ok, results} <- Query.perform(request)
    do
      conn
      |> put_status(200)
      |> render("results.json", results: results)
    end
  end
end
