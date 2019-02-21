extends VBoxContainer


func _ready():
	$Slider.value = global.mouse_sensitivity


func _on_Slider_value_changed(value):
	global.emit_signal('mouse_sensitivity_changed', value)
