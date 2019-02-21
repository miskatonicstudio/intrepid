extends Spatial

onready var keypad_interactive = $KeypadInteractive
onready var switch_interactive = $SwitchInteractive
onready var lock_popup = $PowerPanelLock

var current_switch_rotation = 0

func _ready():
	global.connect('power_panel_unlocked', self, '_on_PowerPanelLock_unlocked')


func _on_LidInteractive_activated():
	$Hinge.play()
	$AnimationPlayer.play('open_lid')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'open_lid':
		keypad_interactive.enable_raycast()
	if anim_name == 'open_pane':
		$SwitchInteractive.enable_raycast()


func _on_KeypadInteractive_activated():
	lock_popup.popup()


func _on_SwitchInteractive_activated():
	$Switch.play()
	var tween = $Tween
	
	tween.start()
	tween.interpolate_method(
		self, 'rotate_switch', 0, -180,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)


func rotate_switch(degrees):
	var delta_degrees = degrees - current_switch_rotation
	current_switch_rotation = degrees
	$SwitchPods.rotate_z(deg2rad(delta_degrees))
	


func _on_PowerPanelLock_unlocked():
	keypad_interactive.queue_free()
	$AnimationPlayer.play('open_pane')
	$Glass.play()


func _on_Tween_tween_completed(object, key):
	global.emit_signal('escape_door_available')
