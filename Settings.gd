extends CenterContainer


func _ready():
	$HBoxContainer/VBoxContainer2/Fullscreen.pressed = global.fullscreen_enabled
	$HBoxContainer/VBoxContainer/Reflections.pressed = global.reflections_enabled
	$HBoxContainer/VBoxContainer/Glow.pressed = global.glow_enabled
	$HBoxContainer/VBoxContainer/Shadows.pressed = global.shadows_enabled


func _on_Shadows_toggled(button_pressed):
	global.emit_signal('shadows_changed', button_pressed)


func _on_Glow_toggled(button_pressed):
	global.emit_signal('glow_changed', button_pressed)


func _on_Reflections_toggled(button_pressed):
	global.emit_signal('reflections_changed', button_pressed)


func _on_Fullscreen_toggled(button_pressed):
	global.emit_signal('fullscreen_changed', button_pressed)
