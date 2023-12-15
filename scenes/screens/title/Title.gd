extends PanelContainer

var _packed_allpokes = preload("res://scenes/screens/all_pokes_grid/AllPokesGrid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_pokedex_pressed():
	var new_scene = _packed_allpokes.instantiate()
	SceneManager.go_to_scene_node(new_scene)
