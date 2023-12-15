extends PanelContainer



@onready var popup : PopupPanel = $PopupPanel

var _abilities = []
var _ability_data = {}
var _chosen_slot = 0


func _open_popup(slot):
	%LabelPopupAbilityName.text = ""
	%LabelPopupEffect.text = ""
	%BtnAbility1.button_pressed = false
	%BtnAbility2.button_pressed = false
	%BtnAbilityHidden.button_pressed = false
	
	#%AbilityScroll.custom_minimum_size.y = 0
	#$PopupPanel.size.y = 0
	#popup.popup()
	if slot != _chosen_slot:
		_chosen_slot = slot
		req_ability()
	else:
		build_popup()


func make(abilities):
	_abilities = abilities
	build()


func build():
	%BtnAbility2.visible = false
	for i in range(_abilities.size()):
		pass
	
	for ability in _abilities:
		if ability["is_hidden"] == true:
			%BtnAbilityHidden.text = ability.ability.name.capitalize() + " (hidden)"
			%BtnAbilityHidden.visible = true
		elif ability.slot == 1:
			%BtnAbility1.text = ability.ability.name.capitalize()
		elif ability.slot == 2:
			%BtnAbility2.text = ability.ability.name.capitalize()
			%BtnAbility2.visible = true


func req_ability():
	var url = ""
	for ability in _abilities:
		if ability.slot == _chosen_slot:
			url = ability.ability.url
	$HTTPRequestAbility.request(url)

func req_ability_completed(result, _response_code, _headers, body):
	_ability_data = RequestHelper.response_from_body(body)
	_ability_data.effect_entries = _ability_data.effect_entries.filter(func(e): return e.language.name == "en")
	_ability_data.names = _ability_data.names.filter(func(e): return e.language.name == "en")
	build_popup()


func build_popup():
	if not _ability_data: return
	%LabelPopupAbilityName.text = _ability_data.names[0].name
	print("text size:", %LabelPopupEffect.size.y)
	if _ability_data.effect_entries.size() > 0:
		%LabelPopupEffect.text = _ability_data.effect_entries[0].effect
	else:
		%LabelPopupEffect.text = "No effect description available."
	
	
	await get_tree().create_timer(0.05).timeout
	print("text size2:", %LabelPopupEffect.size.y)
	#$PopupPanel.size.y = 0
	#popup.popup()
	var height = min(%LabelPopupEffect.size.y, 200)
	var tween = create_tween()
	tween.tween_property(%AbilityScroll, "custom_minimum_size", Vector2(0,height), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequestAbility.request_completed.connect(req_ability_completed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






func _on_btn_ability_1_pressed():
	%BtnAbility1.release_focus()
	_open_popup(1)
	%BtnAbility1.button_pressed = true

func _on_btn_ability_2_pressed():
	%BtnAbility2.release_focus()
	_open_popup(2)
	%BtnAbility2.button_pressed = true

func _on_btn_ability_hidden_pressed():
	%BtnAbilityHidden.release_focus()
	_open_popup(3)
	%BtnAbilityHidden.button_pressed = true
