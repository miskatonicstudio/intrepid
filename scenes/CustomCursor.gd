extends Control

onready var cursor = $Cursor


func _process(delta):
	if cursor.visible:
		cursor.rect_position = get_global_mouse_position()


func enable():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN: # don't move if another popup is open
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_viewport().warp_mouse(get_viewport().size/2)
	$Timer.start()


func disable():
	cursor.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Timer_timeout():
	cursor.show()
