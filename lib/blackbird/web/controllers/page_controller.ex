defmodule Blackbird.Web.PageController do
  use Blackbird.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
