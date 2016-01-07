defmodule Vapir.PageView do
  use Vapir.Web, :view
  
  def message do
    "Hello from the view!"
  end
  
  def apidoc do
	url = "http://127.0.0.1:4000/js/apidoc.json"
	{:ok, {_,_,body}} = :httpc.request('#{url}')
	"#{body}"
  end
end
