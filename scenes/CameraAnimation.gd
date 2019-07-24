extends Spatial

const SEED = 12345678901234

onready var tween = $Tween
onready var timer = $Timer
onready var env = get_world().fallback_environment
onready var animation = $AnimationPlayer


func _ready():
	seed(SEED)
	env.dof_blur_near_enabled = true
	env.dof_blur_far_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Timer_timeout():
	if not animation.is_playing():
		return
	
	env.dof_blur_near_amount = 0
	env.dof_blur_far_amount = 0
	var blur_value = (randf() * 0.3)
	var blur_time = blur_value * 5
	
	timer.wait_time = blur_time
	timer.start()
	
	if blur_value < 0.1:
		return
	
	if blur_time > animation.current_animation_length - animation.current_animation_position:
		return
	
	tween.interpolate_property(
		env, 'dof_blur_far_amount', 0, blur_value,
		blur_time*0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN
	)
	tween.interpolate_property(
		env, 'dof_blur_near_amount', 0, blur_value,
		blur_time*0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN
	)
	tween.interpolate_property(
		env, 'dof_blur_far_amount', blur_value, 0,
		blur_time*0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN, blur_time*0.5
	)
	tween.interpolate_property(
		env, 'dof_blur_near_amount', blur_value, 0,
		blur_time*0.5, Tween.TRANS_SINE, Tween.EASE_OUT_IN, blur_time*0.5
	)
	tween.start()


func _input(event):
	if Input.is_action_just_pressed('skip'):
		get_tree().set_input_as_handled()
		tween.stop_all()
		timer.stop()
		animation.advance(animation.current_animation_length)


func _process(delta):
	$SkyCube.translation = $Camera.translation


func _on_FallSoundDelay_timeout():
	$Camera/Sound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	env.dof_blur_near_enabled = false
	env.dof_blur_far_enabled = false
	global.emit_signal('gameplay_started', $Camera)
	queue_free()
