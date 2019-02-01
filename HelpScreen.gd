extends Container

export (bool) var enabled = true
onready var cursor = $CustomCursor
onready var menu = $CenterContainer/Panel/Menu
onready var confirm = $CenterContainer/Panel/Confirm


func _ready():
	global.connect('gameplay_started', self, '_on_gameplay_started')
	global.connect('escape_door_available', self, '_on_escape_door_available')


func _on_escape_door_available():
	self.enabled = false


func _on_gameplay_started(camera):
	self.enabled = true


func activate_screen():
	show()
	cursor.enable()


func deactivate_screen():
	cursor.disable()
	hide()


func show_confirm():
	menu.hide()
	confirm.show()


func hide_confirm():
	confirm.hide()
	menu.show()


func _on_Exit_pressed():
	show_confirm()


func _input(ev):
	if not enabled:
		return
	
	var popups_are_hidden = true
	for popup in get_tree().get_nodes_in_group('popups'):
		if popup.visible:
			popups_are_hidden = false
			break
	
	if Input.is_action_just_pressed('cancel') and popups_are_hidden:
		get_tree().set_input_as_handled()
		
		if visible:
			if confirm.visible:
				hide_confirm()
			else:
				deactivate_screen()
		else:
			activate_screen()


func _on_Yes_pressed():
	global.goto_scene('res://MainScreen.tscn')


func _on_No_pressed():
	hide_confirm()
