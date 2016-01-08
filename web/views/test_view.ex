defmodule Vapir.TestView do
  use Vapir.Web, :view
  
  def apidoc do
	url = "http://127.0.0.1:4000/js/apidoc.json"
	{:ok, {_,_,body}} = :httpc.request('#{url}')
	json = to_string body
	{:ok, apijson} = JSX.decode json
	generateVapirHTML(apijson)
  end
  
  defp generateVapirHTML(json) do
	html = "<h4>Base URL:</h4><span id=\"base_url\">"<>json["baseURL"]<>"</span>"
	#html = "<pre>Header Info</pre>"
	Map.keys(json["apis"])
		|> generateEndpoints(json,html)
  end
  
  defp generateEndpoints([next|remainder],json,html) do
	html = html<>"<br><b>"<>next<>"</b>"
	paths_list = Map.keys(json["apis"][next]["paths"])
	generatePaths(paths_list, json, html, remainder)
  end
  
  defp generateEndpoints([],_json,html) do
	showHTML(html)
  end
  
  defp generatePaths([next|remainder],json,html, endpoints) do
	html = html<>"<pre>"<>next<>"</pre>"
	generatePaths(remainder, json, html, endpoints)
  end
  
  defp generatePaths([],json,html,endpoints) do
	generateEndpoints(endpoints,json,html)
  end
  
  defp showHTML(html) do
	raw html
  end
end
