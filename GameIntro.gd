extends Container

onready var sound = $Sound


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Tween.interpolate_property(
		sound, 'volume_db', sound.volume_db, -60, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN
	)


func _unhandled_input(event):
	if Input.is_action_just_pressed('skip'):
		get_tree().set_input_as_handled()
		sound.stop()
		$AnimationPlayer.stop()
		$Logo.modulate.a = 0
		$Timer.start()


func go_to_game():
	global.goto_scene('res://Game.tscn')


func _on_AnimationPlayer_animation_finished(anim_name):
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	go_to_game()


func _on_Timer_timeout():
	go_to_game()
