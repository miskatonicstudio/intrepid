extends Spatial


func _ready():
	global.connect('start_opening_escape_door', self, 'open')


func open():
	enable_door()
	$Timer.start()


func enable_door():
	var material = load('res://scenes/Misc02_escape_door.material')
	material.emission_energy = 4


func _on_Timer_timeout():
	$DoorHandleSound.play()
	$AnimationPlayer.play('open')
	$DoorSoundDelay.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	global.emit_signal('escape_door_open')


func _on_DoorSoundDelay_timeout():
	$DoorSound.play()
