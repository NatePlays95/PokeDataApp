extends Control


var _poke_url := ""
var _species_data := {}
var _poke_data := {}
var _image : ImageTexture = null
var _sprites := {}

var _packed_flavortext = preload("res://scenes/components/flavor_text/FlavorText.tscn")
var _packed_evochain = preload("res://scenes/components/evo_chain/EvoChain.tscn")
var _packed_basestats = preload("res://scenes/components/base_stats/BaseStats.tscn")
var _packed_ability = preload("res://scenes/components/ability_view/AbilityList.tscn")


func make(species, poke_url):
	_species_data = species
	_poke_url = poke_url
	#%TexturePokemon.texture = image
	req_poke()


func req_poke():
	%HTTPRequestPoke.request(_poke_url)

func req_poke_completed(_result, _response_code, _headers, body):
	_poke_data = RequestHelper.response_from_body(body)
	build()


func build():
	#for child in %Components.get_children():
	#	child.queue_free()
	
	build_header()
	
	%PokemonPageImage.make(_poke_data.sprites)
	
	#var flavortext_instance = _packed_flavortext.instantiate()
	#flavortext_instance.make(_species_data.flavor_text_entries)
	%FlavorText.make(_species_data.flavor_text_entries)
	#%Components.add_child(flavortext_instance)
	
	#var ability = _packed_ability.instantiate()
	#ability.make(_poke_data.abilities)
	%AbilityList.make(_poke_data.abilities)
	#%Components.add_child(ability)
	
	#var basestats = _packed_basestats.instantiate()
	#basestats.make(_poke_data.stats)
	%BaseStats.make(_poke_data.stats)
	#%Components.add_child(basestats)
	
	#var evochain = _packed_evochain.instantiate()
	#evochain.make(_species_data.evolution_chain)
	%EvoChain.make(_species_data.evolution_chain)
	#%Components.add_child(evochain)


func build_header():
	%LabelPokemonName.text = _species_data.names[0].name
	%LabelPokedexNum.text = "#%04d" % _species_data.pokedex_numbers[0].entry_number
	
	%LabelTypes.text = _poke_data.types[0].type.name.capitalize()
	if _poke_data.types.size() > 1:
		%LabelTypes.text += "/" + _poke_data.types[1].type.name.capitalize()
	
	if _species_data.genera.size() > 0:
		var genera = _species_data.genera.filter(
			func(elem):
				return elem.language.name == "en"
		)[0]
		%LabelGenera.text = genera.genus
	
	%LabelGenera.text += "\nHt. %.1f m   Wt. %.1f kg" % [_poke_data.height/10, _poke_data.weight/10]


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneManager.go_to_previous_scene()


func _enter_tree():
	$VBoxContainer/ScrollContainer.scroll_vertical = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	%HTTPRequestPoke.request_completed.connect(req_poke_completed)
	
	%LabelPokemonName.text = ""
	%LabelGenera.text = ""
	%LabelPokedexNum.text = ""
	%LabelTypes.text = ""


func _on_btn_return_pressed():
	SceneManager.go_to_previous_scene()
