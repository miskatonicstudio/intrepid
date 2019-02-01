extends Spatial

const AMBER = Color('#fca90f')
const BLACK = Color('#000000')
const BLUE = Color('#94e2fc')

onready var animation_player = $AnimationPlayer
onready var led_material = $UsefulModels/SecuritySystemLED.mesh.surface_get_material(0)
onready var keyboard_material = $UsefulModels/SecuritySystemKeyboard.mesh.surface_get_material(0)
onready var keyboard_power_switch_material = $UsefulModels/KeyboardPowerSwitch.mesh.surface_get_material(0)
onready var monitor_power_switch_material = $UsefulModels/MonitorPowerSwitch.mesh.surface_get_material(0)
onready var security_system_popup = $SecuritySystem
onready var planet_schedule_popup = $PlanetSchedule

var lid_open = false
var monitor_power_on = true
var keyboard_power_on = false


func _ready():
	$UsefulModels/SecuritySystemInteractiveScreen.set_screen(security_system_popup.get_screen())
	$UsefulModels/PlanetSchedulerInteractiveScreen.set_screen(planet_schedule_popup.get_screen())
	_update_led()
	_update_keyboard_power()
	_update_monitor_power()


func _update_led():
	var color = BLACK
	if lid_open:
		color = AMBER
		if keyboard_power_on:
			color = BLUE
	led_material.emission = color
	security_system_popup.set_led_color(color)
	security_system_popup.keyboard_enabled = (color == BLUE)


func _update_keyboard_power():
	var switch_emission = 0
	var keyboard_emission = 0.1
	
	if keyboard_power_on:
		switch_emission = 1
		keyboard_emission = 1
	keyboard_power_switch_material.emission_energy = switch_emission
	keyboard_material.emission_energy = keyboard_emission
	_update_led()


func _update_monitor_power():
	var emission = 0
	if monitor_power_on:
		emission = 1
	monitor_power_switch_material.emission_energy = emission
	security_system_popup.set_monitor_active(emission == 1)


func _on_KeyboardButtonInteractive_activated():
	$KeyboardLidButtonSound.play()
	if animation_player.current_animation == 'open_lid':
		return
	$KeyboardLidSound.play()
	if not lid_open:
		animation_player.play('open_lid')
	else:
		animation_player.play_backwards('open_lid')
	lid_open = not lid_open
	_update_led()


func _on_PanelButtonInteractive_activated():
	$PanelUnlockSound.play()
	$PanelLidButtonSound.play()
	animation_player.play('unlock_panel')


func _on_OpenPanelInteractive_activated():
	$PanelHingeSound.play()
	animation_player.play('open_panel')


func _on_KeyboardPowerInteractive_activated():
	$PanelButtonSound.play()
	keyboard_power_on = not keyboard_power_on
	_update_keyboard_power()


func _on_MonitorPowerInteractive2_activated():
	$PanelButtonSound.play()
	monitor_power_on = not monitor_power_on
	_update_monitor_power()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'unlock_panel':
		$UsefulModels/OpenPanelInteractive.enable_raycast()
	elif anim_name == 'open_panel':
		$UsefulModels/MonitorPowerInteractive.enable_raycast()
		$UsefulModels/KeyboardPowerInteractive.enable_raycast()


func _on_SecuritySystemInteractiveScreen_activated():
	security_system_popup.popup()


func _on_PlanetSchedulerInteractiveScreen_activated():
	planet_schedule_popup.popup()
