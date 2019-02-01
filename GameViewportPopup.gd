extends "GamePopup.gd"

export (int) var screen_width
export (int) var screen_height

var viewport = null
var texture_rect = null

func _ready():
	._ready()
	resize_screen(screen_width, screen_height)
	_get_screen_node().texture = get_screen()
	_get_viewport_node().render_target_v_flip = true

func get_screen():
	return _get_viewport_node().get_texture()

func _get_viewport_node():
	print("NOT IMPLEMENTED")

func _get_screen_node():
	print("NOT IMPLEMENTED")

func resize_screen(width, height):
	_get_viewport_node().size = Vector2(width, height)
	_get_screen_node().rect_min_size = Vector2(width, height)