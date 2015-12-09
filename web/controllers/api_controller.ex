defmodule Vapir.APIController do
  use Vapir.Web, :controller

  def index(conn, params) do
	auth = "Basic " <> Base.encode64(params["username"]<>":"<>params["password"])
	url = params["url"]
	{:ok, {_,_,body}} = :httpc.request(:get,{'#{url}',[{'Authorization','#{auth}'}]}, [{:ssl,[{:verify,0}]}], [])
	text conn, "#{body}"
  end
end
