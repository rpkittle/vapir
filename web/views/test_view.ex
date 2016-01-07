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
	#html = "<h4>Base URL:</h4><span id=\"base_url\">"<>json["baseURL"]<>"</span>"
	html = "<pre>Header Info</pre>"
	Map.keys(json["apis"])
		|> generateEndpoints(json,html)
  end
  
  defp generateEndpoints(list,json,html) do
	for x <- list do
		html = html<>"<br>"<>x<>"<br>"
		paths_list = Map.keys(json["apis"][x]["paths"])
		for y <- paths_list do
			generatePaths(y,html)
		end
	end
  end
  
  defp generatePaths(path,html) do
	#[head|tail] = list
	#IO.puts path
	html = html<>"<br>"<>path<>"<br>"
	showHTML(html)
  end
  
  defp showHTML(html) do
	raw html
  end

  defp generateEndpoints([]) do
	IO.puts "Done with Endpoints"
  end
  
  defp generatePaths([]) do
	IO.puts "Done with Paths"
  end
end
