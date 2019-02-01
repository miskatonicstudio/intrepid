extends Container

onready var emergency_screen = $EmergencyScreen
onready var overload_progress = $Blueprint/OverloadProgress
onready var animation_player = $AnimationPlayer


func _process(delta):
	overload_progress.value = 100 - (
		float(global.overload_timer.time_left / global.overload_timer.wait_time) * 50
	)


func hide_emergency_screen():
	emergency_screen.hide()
#	animation_player.stop()
	animation_player.play("damaged_sector")
	global.emit_signal("emergency_screen_closed")
