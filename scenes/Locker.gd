extends Spatial


const COMBINATION = [4, 7, 3]

onready var tween = $Tween
onready var tumbler_1 = $Door/Tumbler1
onready var tumbler_2 = $Door/Tumbler2
onready var tumbler_3 = $Door/Tumbler3
onready var tumblers = [
	tumbler_1,
	tumbler_2,
	tumbler_3
]
onready var button_material = load('res://scenes/locker_button_material.tres')
onready var interactive_button = $Door/Button/InteractiveButton

var current_combination = [0, 0, 0]
var lock_enabled = true


func _ready():
#	for i in range(3):
#		tumblers[i].rotation_degrees.x = current_combination[i] * 36


func move_tumbler(number):
	$Click.play()
	var index = number - 1
	
	current_combination[index] = current_combination[index] + 1
	
	var current_rotation = tumblers[index].rotation_degrees
	if current_rotation.x >= 360:
		current_rotation.x -= 360
	var target_rotation = Vector3(36 * current_combination[index], 0, 0)
	
	tween.interpolate_property(
		tumblers[index], 'rotation_degrees', current_rotation, target_rotation,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	$Timer.start()
	current_combination[index] = wrapi(current_combination[index], 0, 10)


func _on_InteractiveTumbler1_activated():
	if not lock_enabled:
		return
	move_tumbler(1)


func _on_InteractiveTumbler2_activated():
	if not lock_enabled:
		return
	move_tumbler(2)


func _on_InteractiveTumbler3_activated():
	if not lock_enabled:
		return
	move_tumbler(3)


func _on_Unlock_finished():
	$AnimationPlayer.play('open_door')
	$Hinge.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	$Door/StaticBody.collision_layer = 1


func _on_InventoryPage_activated():
	global.emit_signal('code_page_acquired')


func _on_Timer_timeout():
	if not $Timer.is_stopped():
		return


func _on_InteractiveButton_activated():
	$PressButton.play()
	if not lock_enabled:
		return
	lock_enabled = false
	if current_combination == COMBINATION:
		$Door/Tumbler1/InteractiveTumbler1.queue_free()
		$Door/Tumbler2/InteractiveTumbler2.queue_free()
		$Door/Tumbler3/InteractiveTumbler3.queue_free()
		interactive_button.queue_free()
		$Unlock.play()
		button_material.emission = Color(0, 0.9, 0)
	else:
		button_material.emission = Color(0.9, 0, 0)
		for index in range(3):
			var current_rotation = tumblers[index].rotation_degrees
			var rotation_time = $ButtonTimer.wait_time * 0.1 * current_combination[index]
			tween.interpolate_property(
				tumblers[index], 'rotation_degrees', current_rotation, Vector3(0, 0, 0),
				rotation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
		tween.start()
		current_combination = [0, 0, 0]
	$ButtonTimer.start()


func _on_ButtonTimer_timeout():
	lock_enabled = true
	
	button_material.emission = Color(0, 0, 0)
