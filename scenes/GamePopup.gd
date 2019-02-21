extends Popup

export (bool) var keyboard_enabled = false

onready var custom_cursor = $CustomCursor


func _ready():
	self.add_to_group('popups')
	
	if not self.owner:
		popup()


func _on_about_to_show():
	get_tree().set_input_as_handled()
	global.hide_all_popups()
	custom_cursor.enable()


func _unhandled_key_input(event):
	if not self.visible:
		return
	if Input.is_action_just_pressed('cancel'):
		get_tree().set_input_as_handled()
		hide_with_cursor()
		return
	if keyboard_enabled:
		_handle_user_input(event)


func _handle_user_input(event):
	pass


func hide_with_cursor():
	custom_cursor.disable()
	hide()


func _on_popup_hide():
	pass # replace with function body
