defmodule Vapir.TestController do
  use Vapir.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end