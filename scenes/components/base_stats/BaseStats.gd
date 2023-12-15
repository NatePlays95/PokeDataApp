extends PanelContainer


var _stats = []

var _color_excellent = preload("res://assets/themes/stylebox/stat/stat_cyan.tres")
var _color_good = preload("res://assets/themes/stylebox/stat/stat_darkgreen.tres")
var _color_ok = preload("res://assets/themes/stylebox/stat/stat_lime.tres")
var _color_mediocre = preload("res://assets/themes/stylebox/stat/stat_yellow.tres")
var _color_bad = preload("res://assets/themes/stylebox/stat/stat_orange.tres")
var _color_terrible = preload("res://assets/themes/stylebox/stat/stat_red.tres")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func make(stats):
	_stats = stats
	build()


func build():
	var index = 0
	var sum = 0
	for hbox in %Stats.get_children():
		# total
		if index == 6:
			var label = hbox.get_node("Label2")
			label.text = str(sum)
			break
		
		# normal stat
		var stat_value = _stats[index].base_stat
		var label = hbox.get_node("Control/Label2")
		label.text = str(stat_value)
		var bar = hbox.get_node("ProgressBar")
		bar.value = stat_value
		
		set_bar_color(bar, stat_value)
		
		index += 1
		sum += stat_value


func set_bar_color(bar:ProgressBar, stat:int):
	var chosen_theme
	if stat >= 150:
		chosen_theme = _color_excellent
	elif stat >= 120:
		chosen_theme = _color_good
	elif stat >= 90:
		chosen_theme = _color_ok
	elif stat >= 60:
		chosen_theme = _color_mediocre
	elif stat >= 30:
		chosen_theme = _color_bad
	elif stat >= 1:
		chosen_theme = _color_terrible
	
	bar.add_theme_stylebox_override("fill", chosen_theme)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
