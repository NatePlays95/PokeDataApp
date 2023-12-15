extends PanelContainer


var _url := ""
var _evolution_chain := {}

var _packed_pokeview = preload("res://scenes/components/poke_preview/PokeviewSmall.tscn")

func make(evo_chain_source):
	#_evolution_chain = evo_chain
	#build()
	_url = evo_chain_source.url
	%HTTPRequestChain.request(_url)


func build():
	var first_step = _evolution_chain.chain
	var node : Node = make_step(first_step)
	%VBox.add_child(node)


# recursive, how neat.
func make_step(current_step:Dictionary) -> Node:
	var hbox = HBoxContainer.new()
	var vbox = VBoxContainer.new()
	
	var current_step_node = _packed_pokeview.instantiate()
	hbox.add_child(current_step_node)
	current_step_node.make(current_step.species.name, current_step.species.url)
	
	
	for step in current_step.evolves_to:
		var step_node = make_step(step)
		vbox.add_child(step_node)
	hbox.add_child(vbox)
	
	return hbox


# Called when the node enters the scene tree for the first time.
func _ready():
	%HTTPRequestChain.request_completed.connect(_request_chain_completed)
	
	#if _url:
	#	%HTTPRequestChain.request(_url)


func _request_chain_completed(result, response_code, headers, body) -> void:
	var data = RequestHelper.response_from_body(body)
	_evolution_chain = data
	build()
