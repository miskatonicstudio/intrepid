extends Control


func _ready():
	$CustomCursor.enable()


func _on_Game_pressed():
	global.goto_scene('res://scenes/GameIntro.tscn')


func _on_Settings_pressed():
	toggle_settings(true)


func _on_Back_pressed():
	toggle_settings(false)


func _on_Credits_pressed():
	global.goto_scene('res://scenes/Credits.tscn')


func _on_Exit_pressed():
	get_tree().quit()


func toggle_settings(settings_on):
	if settings_on:
		$SettingsButtons.show()
		$MenuButtons.hide()
	else:
		$MenuButtons.show()
		$SettingsButtons.hide()


func toggle_resources(resources_on):
	if resources_on:
		$Resources.show()
		$MenuButtons.hide()
	else:
		$MenuButtons.show()
		$Resources.hide()


func _input(event):
	if Input.is_action_just_pressed('cancel'):
		toggle_settings(false)
		toggle_resources(false)


func _on_BackFromResources_pressed():
	toggle_resources(false)


func _on_Resources_pressed():
	toggle_resources(true)
