extends Spatial

onready var animation = $AnimationPlayer
onready var timer = $DoorClosingDelay
onready var opening_sound = $Spatial/Door/OpeningSound
onready var closing_sound = $Spatial/Door/ClosingSound


func _ready():
	global.connect('gameplay_started', self, 'skip_animation')


func _on_Timer_timeout():
	animation.play_backwards("open")
	closing_sound.play()


func skip_animation(camera):
	timer.stop()
	$DoorOpenSoundDelay.stop()
	animation.seek(0, true) # make sure the door is closed
	animation.stop(true)
	opening_sound.stop()
	closing_sound.stop()


func _on_DoorOpenSoundDelay_timeout():
	opening_sound.play()