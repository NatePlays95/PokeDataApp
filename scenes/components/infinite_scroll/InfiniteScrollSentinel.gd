class_name InfiniteScrollSentinel
extends ColorRect


enum Mode {TOP, BOTTOM}
@export var mode : Mode = Mode.BOTTOM


# Called when the node enters the scene tree for the first time.
func _ready():
	#custom_minimum_size.y = 12
	match mode:
		Mode.TOP:
			size_flags_vertical = SIZE_SHRINK_BEGIN
			
		Mode.BOTTOM:
			size_flags_vertical = SIZE_SHRINK_END
	
	var notifier = VisibleOnScreenNotifier2D.new()
	add_child(notifier)
	notifier.screen_entered.connect(_on_notifier_screen_entered)
	notifier.screen_exited.connect(_on_notifier_screen_exited)


signal screen_entered
func _on_notifier_screen_entered():
	screen_entered.emit()

signal screen_exited
func _on_notifier_screen_exited():
	screen_exited.emit()
