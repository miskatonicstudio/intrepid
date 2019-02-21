extends Control

func _ready():
	pass

func setup(hotkey, texture):
	$Icon.texture = texture
	$Icon/HotKey.text = 'F' + hotkey
