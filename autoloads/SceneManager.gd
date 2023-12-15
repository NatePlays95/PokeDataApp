extends Node

signal scene_changed(new_scene:Node)

var _stored_scene_stack := []

func get_scene_stack():
	var stack = _stored_scene_stack.duplicate()
	stack.push_front(get_tree().current_scene)
	return stack


func go_to_scene_node(scene:Node):
	_stored_scene_stack.push_front(get_tree().current_scene)
	get_tree().root.remove_child(get_tree().current_scene)
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	
	scene_changed.emit(scene)
	print_debug(get_scene_stack())


func go_to_previous_scene():
	await get_tree().create_timer(0.1).timeout
	
	var previous_scene = _stored_scene_stack.pop_front()
	if not previous_scene:
		print_debug("already at the top of scene stack.")
		return
	
	var current_scene = get_tree().current_scene
	current_scene.queue_free() # automatically removed from root
	
	get_tree().root.add_child(previous_scene)
	get_tree().current_scene = previous_scene
	
	scene_changed.emit(previous_scene)
	print_debug(get_scene_stack())


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		var ev = InputEventAction.new()
		ev.action = "ui_cancel"
		ev.pressed = true
		Input.parse_input_event(ev)



