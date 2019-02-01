extends Node

export (int) var number_of_shakes = 12
export (int) var final_shake_sec = 8
export (int) var fadeout_sec = 2
export (bool) var shaking_enabled = false

onready var explosion_timer = $ExplosionTimer
onready var tween = $Tween
onready var sound = $Sound

var current_shake = 0


func _ready():
	explosion_timer.wait_time = final_shake_sec + fadeout_sec
	tween.start()
	global.connect('escape_door_available', self, '_on_escape_door_available')
	global.connect('gameplay_started', self, '_on_gameplay_started')


func _on_escape_door_available():
	shaking_enabled = false


func _on_gameplay_started(camera):
	shaking_enabled = true


func _process(delta):
	if not shaking_enabled:
		return
	var ratio = 1 - float(global.overload_timer.time_left) / global.overload_timer.wait_time
	var shake_progress = number_of_shakes * ratio
	if int(shake_progress) <= current_shake:
		return
	current_shake += 1
	
	var intensity = float(current_shake) / number_of_shakes
	var is_final = current_shake == number_of_shakes
	var time = final_shake_sec if is_final else intensity * 4
	
	global.emit_signal('shake_camera', intensity, is_final)
#	var top_volume_db = intensity * 4
	sound.volume_db = intensity * 4	
	sound.play()
	
	if not is_final:
		tween.interpolate_property(
			sound, 'volume_db', sound.volume_db, -60, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
#		tween.interpolate_property(
#			sound, 'volume_db', -60, top_volume_db, time*0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT
#		)
#		tween.interpolate_property(
#			sound, 'volume_db', top_volume_db, -60, time*0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT,
#			time*0.3
#		)
	else:
		shaking_enabled = false
		$Explosion.show()
		$ExplosionTimer.start()
		tween.interpolate_property(
			$Explosion, 'self_modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), final_shake_sec / 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, final_shake_sec / 2
		)
		tween.interpolate_property(
			$Explosion, 'self_modulate', Color(1, 1, 1, 1), Color(0, 0, 0, 1), fadeout_sec,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, final_shake_sec
		)
#		tween.interpolate_property(
#			sound, 'volume_db', -60, top_volume_db, final_shake_sec*0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT
#		)
		tween.interpolate_property(
			sound, 'volume_db', sound.volume_db, -60, fadeout_sec,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT, final_shake_sec
		)


func _on_ExplosionTimer_timeout():
	global.emit_signal('player_died')
