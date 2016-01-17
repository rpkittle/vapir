$(function() {
	function syntaxHighlight(json) {
		json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
		return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
			var cls = 'number';
			if (/^"/.test(match)) {
				if (/:$/.test(match)) {
					cls = 'key';
				} else {
					cls = 'string';
				}
			} else if (/true|false/.test(match)) {
				cls = 'boolean';
			} else if (/null/.test(match)) {
				cls = 'null';
			}
			return '<span class="' + cls + '">' + match + '</span>';
		});
	}
	
	$( ".method" ).click(function() {
		if ($(this).parent().siblings(".endpoint_content").is(":visible")) {
			$( ".method" ).parent().siblings(".endpoint_content").hide( "fast" );
		} else {
			$( ".method" ).parent().siblings(".endpoint_content").hide( "fast" );
			$(this).parent().siblings(".endpoint_content").toggle( "fast" );
		}
	});

	$( "span.resource" ).click(function() {
	  $(this).siblings("ul").toggle( "fast" );
	});
	
	$(".TryItNow").click( function() {
		//var url = "http://www.omdbapi.com/?t=Avatar";
		var base_url = $('#base_url').text();
		var endpoint_url = $(this).parent().siblings(".endpoint_header").children(".url").attr("value");
		var url = base_url+endpoint_url;
		
		var inputs = $(this).siblings(".params").find("input");
		$.each($(inputs).serializeArray(), function(i, field) {
			//params[field.name] = field.value;
			var name = field.name.slice(0, -6);
			var value = field.value;
			url = url.replace("{"+name+"}",value);
			//alert(url)
		});
		//alert(url);
		
		var username = $('#api_username').val();
		var password = $('#api_password').val();
		var method = "GET";
		var dom = this;
		$.get("http://127.0.0.1:4000/api/?url=" + url + "&username=" + username + "&password=" + password).success(function(data){
			var results = data.split("\n\n");
			var header_data = results[1].replace(/\[/g,"[ ");
			header_data = header_data.replace(/(\[|\},?)/g,"$1\n");
			var json_data = JSON.parse(results[2].slice(1,-1));
			json_data = syntaxHighlight(JSON.stringify(json_data, undefined, 4));
			$(dom).siblings(".response").children(".code.return").html("<pre>" + results[0] + "</pre>");
			$(dom).siblings(".response").children(".code.headers").html("<pre>" + header_data + "</pre>");
			$(dom).siblings(".response").children(".code.response").html("<pre>"+json_data+"</pref>");
		})
		
		//show Response stuff
		$(this).siblings( ".response" ).show( "fast" );
		$(this).siblings(".reset_res").show("fast")
		
		//populate data
		$(this).siblings(".response").children(".code.curl").html("<pre>curl -k -X "+method+" -u "+username+":"+password+" \""+url+"\"</pre>");
	});
	
	$( ".reset_res" ).click(function() {
		$(this).siblings(".response").hide( "fast" );
		$(this).hide("fast")
		//remove data
		var path = $(this).siblings(".response");
		path.children(".code.return").html("<pre></pre>");
		path.children(".code.headers").html("<pre></pre>");
		path.children(".code.response").html("<pre></pref>");
	});
});