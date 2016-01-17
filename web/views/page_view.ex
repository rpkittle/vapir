defmodule Vapir.PageView do
  use Vapir.Web, :view
  
  def apidoc do
	url = "http://127.0.0.1:4000/js/apidoc.json"
	{:ok, {_,_,body}} = :httpc.request('#{url}')
	json = to_string body
	{:ok, apijson} = JSX.decode json
	generateVapirHTML(apijson)
  end
  
  defp generateVapirHTML(json) do
	html = """
	<h4>Base URL:</h4>
	<span id=\"base_url\">#{json["baseURL"]}</span>
	<ul id="resources">
	"""
	Map.keys(json["apis"])
		|> generateEndpoints(json,html)
  end
  
  defp generateEndpoints([next|rem_endpoints],json,html) do
	#html = html<>"<br><b>"<>next<>"</b>"
	html = html<>"""
        <li id="resource-Example">
          <span class="resource">#{next}</span>
		  <ul class="endpoints" style="display: none;">
	"""
	paths_map = json["apis"][next]["paths"]
	Map.keys(paths_map) # list of paths
		|> generatePaths(json, html, rem_endpoints, paths_map)
  end
  
  defp generateEndpoints([],_json,html) do
	html = html<>"""
    </ul>
	"""
	showHTML(html)
  end
  
  defp generatePaths([next|rem_paths],json,html,rem_endpoints, paths_map) do
	Map.keys(paths_map[next]) # get, put, etc
		|> generateMethods(json,html,rem_endpoints,paths_map,rem_paths,next)
  end
  
  defp generatePaths([],json,html,rem_endpoints, paths_map) do
	html = html<>"""
	</ul>
        </li>
	"""
	generateEndpoints(rem_endpoints,json,html)
  end
  
  defp generateMethods([next|rem_methods],json,html,rem_endpoints,paths_map,rem_paths,curr_path) do
	param_map = paths_map[curr_path][next]["parameters"]
	html = html<>"""
			<li class="#{next}">
              <div class="endpoint_header">
                <span class="method">#{next}</span>
                <span class="url" value="#{curr_path}">#{curr_path} - #{paths_map[curr_path][next]["summary"]}</span>
              </div>
              <div class="endpoint_content" style="display: none;">
                <h4>Descriptions</h4>
                <span class="markdown">#{paths_map[curr_path][next]["description"]}</span>
                <h4>Parameters</h4>
				<span class="markdown">show available parameters with input fields</span>
				<pre class="params"><table>
						<tr>
							<th>Name</th><th>Input</th><th>Description</th><th>Format</th><th>Required</th>
						</tr>
						#{generateParams(Map.keys(param_map), param_map, "")}
					</table></pre>
                <br>
                <button class="TryItNow">Try it now!</button><span class="reset_res" style="display:none">Reset</span>
				<div class="response" style="display:none">
					<h4>CURL Command:</h4><div class="code curl"></div>
					<h4>Return Code:</h4><div class="code return"></div>
					<h4>Headers:</h4><div class="code headers"></div>
					<h4>Response:</h4><div class="code response"></div>
				</div>
              </div>
            </li>
	"""
	generateMethods(rem_methods,json,html,rem_endpoints,paths_map,rem_paths,curr_path)
  end
  
  defp generateMethods([],json,html,rem_endpoints,paths_map,rem_paths,curr_paths) do
	generatePaths(rem_paths,json,html,rem_endpoints, paths_map)
  end
  
  defp generateParams([next|remainder], param_map, param_html) do
	param_html = param_html<>"""
	<tr><td>#{next}:</td><td><input placeholder="#{"example"}" id="#{next}_value" name="#{next}_value" type="text"></td><td>#{param_map[next]["description"]}</td><td>#{param_map[next]["format"]}</td><td>#{param_map[next]["required"]}</td></tr>
	"""
	generateParams(remainder, param_map, param_html)
  end
  
  defp generateParams([], param_map, param_html) do
	param_html
  end
  
  defp showHTML(html) do
	raw html
  end
end
