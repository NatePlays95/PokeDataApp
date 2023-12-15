class_name InfiniteScrollContainer
extends ScrollContainer


signal bottom_reached
signal top_reached

## used to determine scroll ratio.
## this child needs a Fill+Expand size flag.
@export var immediate_child : Control = null

@export var scroll_margin_bottom : int = 0

var _sentinel_top : InfiniteScrollSentinel = null
var _sentinel_bottom : InfiniteScrollSentinel = null
var _last_scroll_ratio := 0.0


func get_scroll_ratio() -> float:
	return self.scroll_vertical / (immediate_child.size.y - self.size.y)

func get_scroll_ratio_absolute() -> Array:
	return [self.scroll_vertical, immediate_child.size.y - self.size.y]


# Called when the node enters the scene tree for the first time.
func _ready():
	if not immediate_child:
		immediate_child = get_children()[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var ratio_array = get_scroll_ratio_absolute()
	var current_ratio = get_scroll_ratio()
	
	if current_ratio != _last_scroll_ratio:
		if scroll_margin_bottom != 0:
			if ratio_array[0] >= ratio_array[1] - scroll_margin_bottom:
				#print_debug("bottom")
				bottom_reached.emit()
		if scroll_margin_bottom == 0 and current_ratio == 1.0: 
			#print_debug("bottom")
			bottom_reached.emit()
		if current_ratio == 0.0: 
			#print_debug("top")
			top_reached.emit()
		_last_scroll_ratio = current_ratio


