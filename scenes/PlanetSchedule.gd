extends "GameViewportPopup.gd"


var scrolling = false


func _ready():
	._ready()
	

func _get_viewport_node():
	return $Viewport


func _get_screen_node():
	return $CenterContainer/TextureRect


func _on_TextureRect_gui_input(ev):
	if Input.is_action_just_pressed('click'):
		scrolling = true
	elif Input.is_action_just_released('click'):
		scrolling = false
	elif ev is InputEventMouseMotion and scrolling:
		$Viewport/PlanetScheduleScreenContent.scroll(-ev.relative.y)
