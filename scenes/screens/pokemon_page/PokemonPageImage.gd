extends PanelContainer



var _sprites := {}
var _texture_normal : ImageTexture = null
var _texture_shiny : ImageTexture = null



func toggle_shiny(should_be_shiny):
	%TexNormal.visible = not should_be_shiny
	%TexShiny.visible = should_be_shiny


func make(sprites):
	_sprites = sprites
	req_image()
	req_shiny()


func req_image():
	var image_url = ""
	if _sprites.other["official-artwork"]: 
		if _sprites.other["official-artwork"].front_default:
			image_url = _sprites.other["official-artwork"].front_default
	if image_url:
		$HTTPRequestImage.request(image_url)


func req_image_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	%TexNormal.texture = ImageTexture.create_from_image(image)
	toggle_shiny(false)


func req_shiny():
	var image_url = ""
	if _sprites.other["official-artwork"]: 
		if _sprites.other["official-artwork"].front_shiny:
			image_url = _sprites.other["official-artwork"].front_shiny
	if image_url:
		$HTTPRequestShiny.request(image_url)


func req_shiny_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	%TexShiny.texture = ImageTexture.create_from_image(image)



# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequestImage.request_completed.connect(req_image_completed)
	$HTTPRequestShiny.request_completed.connect(req_shiny_completed)


func _on_btn_shiny_toggled(toggled_on):
	toggle_shiny(toggled_on)
