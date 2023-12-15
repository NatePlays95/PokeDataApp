extends Control


@onready var http_image = $http_image
@onready var http_pokemon = $http_pokemon


func req_pokemon_request_completed(result, response_code, headers, body):
	print("POKEMON REQUEST RETURNED")
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Request was not successful.")
		return
	
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	# Also request image
	if response.sprites.other["official-artwork"]:
		var artwork_url = response.sprites.other["official-artwork"].front_default
		req_image(artwork_url)
	else:
		var artwork_url = response.sprites.front_default
		req_image(artwork_url)
	
	update_view(response)


func req_image(url:String) -> void:
	var error = http_image.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	#var request_result = await http_image.request_completed
	# result, status code, response headers, and body are now in indices 0, 1, 2, and 3 of response

func req_image_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("deu ruim")
		return
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
		return
	var texture = ImageTexture.create_from_image(image)
	%tex_pokemon.texture = texture


func update_view(data:Dictionary):
	%lbl_pokename.text = "Name: %s" % [data.name.capitalize()]
	
	var info = %lbl_pokeinfo
	info.text = "Type: "
	for type in data.types:
		info.text += type.type.name + " "
	info.text += "\n"
	for stat in data.stats:
		info.text += "%s: %d\n" % [stat.stat.name.capitalize(), stat.base_stat]
	info.text += "\n"


# Called when the node enters the scene tree for the first time.
func _ready():
	http_image.request_completed.connect(req_image_request_completed)
	http_pokemon.request_completed.connect(req_pokemon_request_completed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_http_request_request_completed(result, response_code, headers, body):
	print("REQUEST RETURNED")
	#print(headers.purpose)
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("deu ruim")
		return
	
	#print(headers)
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if !response:
		push_error("sem resposta?")
		return
	
	#print(response.sprites.front_default)
	
	%lbl_pokename.text = "Name: %s" % [response.name.capitalize()]
	
	var lbl_info = %lbl_pokeinfo
	lbl_info.text = "Type: "
	for type in response.types:
		lbl_info.text += type.type.name + " "
	lbl_info.text += "\n"
	for stat in response.stats:
		lbl_info.text += "%s: %d\n" % [stat.stat.name.capitalize(), stat.base_stat]
	lbl_info.text += "\n"
	
	#download_image(response.sprites.front_default)
	if response.sprites.other["official-artwork"]:
		var artwork_url = response.sprites.other["official-artwork"].front_default
		req_image(artwork_url)
	else:
		var artwork_url = response.sprites.front_default
		req_image(artwork_url)
	
	pass # Replace with function body.


func _on_search_text_submitted(new_text):
	var url : String = "https://pokeapi.co/api/v2/pokemon/%s/" % %search.text.to_lower()
	$http_pokemon.request(url)
