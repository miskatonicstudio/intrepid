extends Container

onready var console = $ConsoleScreen
onready var tween = $Tween
onready var sound = $Sound
onready var delay_timer = $DelayAfterTypingFinished
onready var blindfold_timer = $BlindfoldTimer


func _ready():
	var screen_width
	if OS.window_fullscreen:
		screen_width = OS.get_screen_size().x
	else:
		screen_width = get_viewport().size.x # TODO: check this for fullscreen
	console.font.size = 0.0625 * screen_width
	$CRT.material.set_shader_param("screen_base_size", int(0.15625 * screen_width))
	var survivors = 1 if global.survived else 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	console.console_output = [
		1,
		"Report #167347", 0.7,
		"\nVessel ID: FSS45F093", 0.5,
		"\nVessel Name: Intrepid", 0.5,
		"\nIncident: Reactor meltdown", 1,
		"\nCause: ", 0.5, "Critical hull damage", 1,
		"\nCrew: ", 0.5, '4', 1,
		"\nSurvivors: ", 3, str(survivors), 2
	]
	tween.start()
	console.start_line_processing()


func _unhandled_input(event):
	if Input.is_action_just_pressed("cancel"):
		go_to_credits()


func set_sound_volume(volume):
	sound.volume_db = volume


func set_blindfold_visibility(visibility):
	$Blindfold.self_modulate.a = visibility


func go_to_credits():
	global.goto_scene('res://scenes/Credits.tscn')


func _on_ConsoleScreen_finished_typing():
	delay_timer.start()


func _on_DelayAfterTypingFinished_timeout():
	blindfold_timer.start()
	tween.interpolate_method(
		self, "set_sound_volume", sound.volume_db, -60,
		blindfold_timer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.interpolate_method(
		self, "set_blindfold_visibility", 0, 1,
		blindfold_timer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)


func _on_BlindfoldTimer_timeout():
	go_to_credits()
