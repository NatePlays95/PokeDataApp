extends Node


var _request_cache := {}

var _pokeview_cache := {}

func response_from_body(body) -> Dictionary:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	return response


func check_pokeview_cache(url:String) -> Dictionary:
	return _request_cache.get(url, {})

func add_to_pokeview_cache(url:String, data:Dictionary, image_url:String) -> void:
	if data and not _request_cache.has(url):
		data.sprites.merge({"image_url":image_url})
		_request_cache[url] = {
			"name": data.name,
			"types": data.types,
			"sprites": data.sprites
		}




func check_request_cache(url:String) -> Dictionary:
	return _request_cache.get(url, {})

func add_to_request_cache(url:String, data:Dictionary) -> void:
	if data and not _request_cache.has(url):
		_request_cache[url] = data


# FIXME: remove
func check_image_cache(url:String) -> Dictionary:
	return {}
# FIXME: remove
func add_to_image_cache(url:String, image) -> void:
	pass
