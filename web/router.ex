defmodule Vapir.Router do
  use Vapir.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Vapir do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
  
  scope "/api", Vapir do
    pipe_through :api

    get "/", APIController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Vapir do
  #   pipe_through :api
  # end
end
