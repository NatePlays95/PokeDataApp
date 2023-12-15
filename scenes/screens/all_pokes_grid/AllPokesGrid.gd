extends Control



var _packed_pokeview : PackedScene = preload("res://scenes/components/poke_preview/PokeviewSmall.tscn")

var _full_species_list : Array = []
var _species_list : Array = []

var _is_loading_species := false

var _load_step_size := 24
var _sliding_window_width = 30
var _species_load_index : int = 0
var _load_index_start := 0
var _load_index_end := 0

var _hardcoded_scroll_offset = 1969


func set_species_list(list) -> void:
	_species_list = list
	_species_load_index = 0
	_load_index_start = 0
	_load_index_end = 0
	%Scroll.scroll_vertical = 0
	for child in %GridPokemon.get_children():
		child.queue_free()


func req_allpokes() -> void:
	$HTTPRequestAllPokes.request("https://pokeapi.co/api/v2/pokemon-species?limit=100000&offset=0")
	pass


func req_allpokes_completed(result, response_code, headers, body) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Request was not successful.")
		return
	
	
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	_full_species_list = response.results
	set_species_list(_full_species_list)
	
	_load_bottom()


func _load_top():
	if not _species_list: return
	if _load_index_start <= 0: return
	_is_loading_species = true
	var first_index = _load_index_start
	
	#var old_children = %GridPokemon.get_children()
	#for child in old_children:
	#	%GridPokemon.remove_child(child)
	
	var order = 0
	for i in range(first_index-_load_step_size, first_index+_load_step_size):
		if i < 0: continue
		
		var species = _species_list[i]
		var instance = _packed_pokeview.instantiate()
		instance.make(species.name, species.url)
		%GridPokemon.add_child(instance)
		%GridPokemon.move_child(instance, order)
		
		order += 1
	
	#for child in old_children:
	#	%GridPokemon.add_child(child)
	
	_load_index_start = max(0, _load_index_start - _load_step_size)
	
	_is_loading_species = false


func _deload_top():
	if not _species_list: return
	_is_loading_species = true
	
	var child_count = %GridPokemon.get_child_count()
	var extra_children = child_count - _sliding_window_width
	if extra_children > 0:
		var children = %GridPokemon.get_children()
		var removed_count = 0
		for i in range(0, extra_children):
			children[i].destroy()
			removed_count = i
		_load_index_start += removed_count

	_is_loading_species = false


func _load_bottom():
	if not _species_list: return
	if _load_index_end >= _species_list.size(): return
	_is_loading_species = true
	var first_index = _load_index_end
	
	for i in range(first_index, first_index+_load_step_size):
		if i >= _species_list.size(): break
		
		var species = _species_list[i]
		var instance = _packed_pokeview.instantiate()
		instance.make(species.name, species.url)
		%GridPokemon.add_child(instance)
		_load_index_end = i
	
	_load_index_end += 1
	_is_loading_species = false


func _deload_bottom():
	if not _species_list: return
	_is_loading_species = true
	
	var child_count = %GridPokemon.get_child_count()
	var extra_children = child_count - _sliding_window_width
	if extra_children > 0:
		var children = %GridPokemon.get_children()
		var removed_count = 0
		for i in range(1, extra_children+1):
			children[-i].destroy()
			removed_count = i
		_load_index_end -= removed_count
	
	#_load_index_end += 1
	_is_loading_species = false



func on_search_submitted(search_text : String) -> void:
	if search_text == "":
		set_species_list(_full_species_list)
		_load_bottom()
		return
	
	var search_array = search_text.split(" ")
	
	var search_list = _full_species_list.filter(
		func(species):
			var species_name : String = species.name
			var result = true
			for word in search_array:
				result = word.to_lower() in species_name and result
			return result
	)
	set_species_list(search_list)
	_load_bottom()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneManager.go_to_previous_scene()

func _on_btn_return_pressed():
	SceneManager.go_to_previous_scene()


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequestAllPokes.request_completed.connect(req_allpokes_completed)
	%SearchBar.text_submitted.connect(on_search_submitted)
	req_allpokes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$_Debug/LabelScrollRate.text = "scroll ratio: %f" % %Scroll.get_scroll_ratio()
	$_Debug/LabelScrollRate.text += "\n %d / %d" % %Scroll.get_scroll_ratio_absolute()


func _on_scroll_bottom_reached():
	if not _is_loading_species: 
		#_deload_top()
		#await get_tree().create_timer(0.5).timeout
		_load_bottom()
		print(_load_index_end)


func _on_scroll_top_reached():
	if not _is_loading_species: 
		
		#_load_top()
		#await get_tree().create_timer(0.5).timeout
		print(_load_index_end)
		#_deload_bottom()





func _on_btn_search_glass_pressed():
	%SearchBar.grab_click_focus()


func _on_btn_search_delete_pressed():
	%SearchBar.text = ""
	on_search_submitted("")
