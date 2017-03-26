defmodule Blackbird.Web.Router do
  use Blackbird.Web, :router

  alias Blackbird.Web.TweetsController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    get "/tweets", TweetsController, :search
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blackbird.Web do
  #   pipe_through :api
  # end
end
