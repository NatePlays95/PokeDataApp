extends Button

var _pokepage_packed = preload("res://scenes/screens/pokemon_page/PokemonPage.tscn")


var _species_url := ""
var _poke_url := ""
var _texture_url := ""
var _texture : ImageTexture = null
var _species_data : Dictionary = {}
#var _baseform_data : Dictionary = {}

var _finished := false


func make(poke_name, species_url):
	#await get_tree().create_timer(0.5).timeout
	_species_url = species_url
	#%LabelName.text = poke_name.capitalize()


func req_species():
	$HTTPRequestSpecies.request(_species_url)


func req_species_completed(_result, _response_code, _headers, body):
	var data = RequestHelper.response_from_body(body)
	_species_data = data
	RequestHelper.add_to_request_cache(_species_url, data)
	
	for variety in data.varieties:
		if variety.is_default:
			_poke_url = variety.pokemon.url
	
	_species_data.names = _species_data.names.filter(
		func(n):
			return n.language.name == "en"
	)
	
	var pokedex_num = _species_data.pokedex_numbers[0].entry_number
	var pokemon_name = _species_data.names[0].name
	%LabelName.text = "#%04d - %s" % [pokedex_num,pokemon_name]
	
	req_poke()
	$_Debug/LblSpecies.text = "OK"


func req_poke():
	var cache = RequestHelper.check_pokeview_cache(_poke_url)
	if cache:
		req_poke_completed(0,200,null,null,cache)
	else:
		$HTTPRequestPoke.request(_poke_url)


func req_poke_completed(_result, _response_code, _headers, body, data:Dictionary={}):
	if body and not data:
		data = RequestHelper.response_from_body(body)
	
	req_image(data.sprites)
	
	$_Debug/LblBaseform.text = "OK"
	RequestHelper.add_to_pokeview_cache(_poke_url, data, _texture_url)
	_finished = true


func req_image(sprites) -> void:
	_texture = ImageTexture.new()
	#return
	#image_url = _poke_data.sprites.front_default
	#https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png
	
	#$HTTPRequestImage.request(_texture_url)
	
	_texture_url = sprites.front_default.replace("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/","")
	
	#var image = Image.load_from_file("res://addons/PokeAPI/sprites/"+_texture_url)
	var image = load("res://addons/PokeAPI/sprites/"+_texture_url)
	%TexturePokemon.texture = ImageTexture.create_from_image(image)



func req_image_completed(result, _response_code, _headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Not successful.")
		return
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
		return
	%TexturePokemon.texture = ImageTexture.create_from_image(image)


func _on_pressed():
	if not _species_data or not _poke_url: return
	
	await get_tree().create_timer(0.1).timeout
	var scene_instance = _pokepage_packed.instantiate()
	SceneManager.go_to_scene_node(scene_instance)
	scene_instance.make(_species_data, _poke_url)
	


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequestSpecies.request_completed.connect(req_species_completed)
	$HTTPRequestPoke.request_completed.connect(req_poke_completed)
	$HTTPRequestImage.request_completed.connect(req_image_completed)
	
	self.pressed.connect(_on_pressed)


func _enter_tree():
	if not _species_data:
		call_deferred("req_species")
	elif not _finished or not %TexturePokemon.texture:
		call_deferred("req_poke")


func _exit_tree():
	pass
	#queue_free()
	#_finished = false
	#if _texture: _texture.free()
	#_texture = null
	#%TexturePokemon.texture = null


func destroy():
	_species_data.clear()
	self.queue_free()


var _process_timer := 0.0
func _process(delta):
	if not _finished: 
		_process_timer += delta
		if _process_timer < 2.0: return
		
		#if _baseform_data and _texture:
		#	_finished = true
		#	return
		
		#if _baseform_data and not _texture:
		#	req_image()
		
		#if _poke_url and not _baseform_data:
		#	req_poke()
		
		#if _species_url and not _species_data:
		#	req_species()
		
		_process_timer -= 2.0

