defmodule Vapir.APIController do
  use Vapir.Web, :controller

  def index(conn, params) do
	auth = "Basic " <> Base.encode64(params["username"]<>":"<>params["password"])
	url = params["url"]
	{:ok, {retcode,headers,body}} = :httpc.request(:get,{'#{url}',[{'Authorization','#{auth}'}]}, [{:ssl,[{:verify,0}]}], [])
	content = inspect(retcode)<>"\n\n"<>inspect(headers)<>"\n\n"<>inspect(body)
	text conn, "#{content}"
  end
end
