extends Spatial

export (int) var aligning_time = 2

var step = 'right'
var is_active = false


func _ready():
	global.connect('escape_door_available', self, 'start_aligning')
	global.connect('escape_door_open', self, 'start_animation')


func start_aligning():
	is_active = true
	var starting_camera = get_viewport().get_camera()
	var camera = $Camera
	var tween = $Tween
	
	camera.set_global_transform(starting_camera.get_global_transform())
	camera.make_current()
	
	tween.interpolate_property(
		camera, 'translation', camera.translation, Vector3(0, 1.65, 2), aligning_time,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		camera, 'rotation_degrees', camera.rotation_degrees, Vector3(0, -180, 0), aligning_time,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.start()
	$StepTimer.start()


func _on_Tween_tween_completed(object, key):
	global.emit_signal('start_opening_escape_door')
	$StepTimer.stop()


func start_animation():
	$AnimationPlayer.play('exit')
	$MusicTimer.start()
	$StepTimer.start()
	$LongStepTimer.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'exit':
		$StepTimer.stop()
		$AnimationPlayer.play('fade_out')
	if anim_name == 'fade_out':
		global.emit_signal('player_escaped')


func _on_StepTimer_timeout():
	if step == 'right':
		$Camera/RightStepSound.play()
		step = 'left'
	else:
		$Camera/LeftStepSound.play()
		step = 'right'


func _on_LongStepTimer_timeout():
	$StepTimer.wait_time = 0.7


func _input(ev):
	if Input.is_action_just_pressed('skip') and is_active:
		get_tree().set_input_as_handled()
		global.emit_signal('player_escaped')


func _on_MusicTimer_timeout():
	$Sound.play()
