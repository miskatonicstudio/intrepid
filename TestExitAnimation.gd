extends Spatial


func _input(ev):
	if Input.is_action_just_pressed('click'):
		global.emit_signal('escape_door_available')
