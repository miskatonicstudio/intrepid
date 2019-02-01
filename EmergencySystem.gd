extends "GameViewportPopup.gd"


func _get_viewport_node():
	return $Viewport


func _get_screen_node():
	return $ComputerScreen


func _input(ev):
	if not self.visible:
		return
	if Input.is_action_just_pressed("accept") and $Viewport/Container/EmergencyScreen.visible:
		$Viewport/Container.hide_emergency_screen()
