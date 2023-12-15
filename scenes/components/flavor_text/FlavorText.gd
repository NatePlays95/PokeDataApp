extends PanelContainer


enum DEX_COLOR {RED, BLUE}

var _version_color := {
	"red": Color.RED, "blue": Color.BLUE, "yellow": Color.YELLOW,
	"gold": Color.GOLDENROD, "silver": Color.SILVER, "crystal": Color.DARK_TURQUOISE,
	"ruby": Color.DARK_RED, "sapphire": Color.DARK_BLUE, "emerald": Color.DARK_GREEN,
	"firered": Color.DARK_ORANGE, "leafgreen": Color.GREEN_YELLOW,
	"diamond": Color.SKY_BLUE, "pearl": Color.LIGHT_PINK, "platinum": Color.DIM_GRAY,
	"heartgold": Color.GOLDENROD, "soulsilver": Color.SILVER,
	"black": Color.BLACK, "white": Color.WHITE, "black-2": Color.BLACK, "white-2": Color.WHITE, 
	"colosseum": Color.INDIAN_RED, "xd": Color.DARK_SLATE_BLUE,
	"x": Color.DODGER_BLUE, "y": Color.ORANGE_RED, "omega-ruby": Color.DARK_RED, "alpha-sapphire": Color.DARK_BLUE,
	"sun": Color.DARK_ORANGE, "moon": Color.CORNFLOWER_BLUE, "ultra-sun": Color.SADDLE_BROWN, "ultra-moon": Color.DARK_SLATE_BLUE,
	"lets-go-pikachu": Color.GOLD, "lets-go-eevee": Color.SADDLE_BROWN,
	"sword": Color.DODGER_BLUE, "shield": Color.MAROON, "the-isle-of-armor": Color.YELLOW, "the-crown-tundra": Color.DARK_CYAN,
	"brilliant-diamond": Color.SKY_BLUE, "shining-pearl": Color.LIGHT_PINK, "legends-arceus": Color.DARK_SLATE_GRAY,
	"scarlet": Color.ORANGE_RED, "violet": Color.BLUE_VIOLET,
	"the-teal-mask": Color.TEAL, "the-indigo-disk": Color.INDIGO
}

var _flavor_text_entries := []

var _packed_button = preload("res://scenes/components/flavor_text/FlavorTextButton.tscn")

func make(entries:Array):
	_flavor_text_entries = entries.filter(
		func(entry): 
			return entry.language.name == "en"
	)
	# remove line breaks.
	for entry in _flavor_text_entries:
		#print(entry.flavor_text.split())
		entry.flavor_text = entry.flavor_text.replace("\n", " ")
		entry.flavor_text = entry.flavor_text.replace("\f", " ")
		entry.flavor_text = entry.flavor_text.replace("\t", " ")
		entry.flavor_text = entry.flavor_text.strip_escapes()
	
	build_buttons()
	#toggle(DEX_COLOR.RED)


func build_buttons():
	for i in range(_flavor_text_entries.size()):
		var entry = _flavor_text_entries[i]
		var btn = _packed_button.instantiate()
		btn.name = entry.version.name
		btn.modulate = _version_color[entry.version.name]
		btn.pressed.connect(_on_btn_pressed.bind(i))
		%HBox.add_child(btn)
	
	call_deferred("scroll_to_last")


func toggle(index:int):
	for child in %HBox.get_children():
		child.button_pressed = false
	
	%HBox.get_child(index).button_pressed = true
	%LabelFlavor.text = _flavor_text_entries[index].flavor_text
	%LabelGameName.text = "Pokémon " + _flavor_text_entries[index].version.name.capitalize()


func scroll_to_last():
	if %HBox.get_child_count() == 0: return
	toggle(%HBox.get_child_count() - 1)
	%Scroll.scroll_horizontal = %HBox.size.x - %Scroll.size.x


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_btn_pressed(index:int):
	toggle(index)

func _on_btn_red_pressed():
	toggle(DEX_COLOR.RED)

func _on_btn_blue_pressed():
	toggle(DEX_COLOR.BLUE)
