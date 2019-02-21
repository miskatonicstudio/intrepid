extends Spatial

onready var damaged_light_material = load('res://scenes/Misc01_no_emission.material')

onready var escape_spot_1_light = $EscapePodSpotLight1
onready var escape_spot_2_light = $EscapePodSpotLight2

onready var corridor_escape_lamp = $CorridorEscapeLamp
onready var corridor_middle_lamp = $CorridorMiddleLamp
onready var corridor_rest_lamp = $CorridorRestLamp

onready var chill_far_lamp = $ChillFarLamp
onready var chill_wall_lamp = $ChillWallLamp

var keep_escape_lamp_on = false
var flicker_on = true


func _ready():
	global.connect('escape_door_available', self, '_on_escape_door_available')
	global._on_shadows_changed(global.shadows_enabled)


func _on_escape_door_available():
	chill_far_lamp.visible = false
	chill_wall_lamp.visible = false
	corridor_middle_lamp.visible = false
	corridor_rest_lamp.visible = false
	
	corridor_escape_lamp.visible = true
	keep_escape_lamp_on = true

	escape_spot_1_light.show()
	escape_spot_2_light.show()


func _on_ChillFarArea_body_entered(body):
	chill_far_lamp.visible = true


func _on_ChillFarArea_body_exited(body):
	chill_far_lamp.visible = false


func _on_ChillWallArea_body_entered(body):
	chill_wall_lamp.visible = true


func _on_ChillWallArea_body_exited(body):
	chill_wall_lamp.visible = false


func _on_CorridorEscapeArea_body_entered(body):
	corridor_escape_lamp.visible = true


func _on_CorridorEscapeArea_body_exited(body):
	if not keep_escape_lamp_on:
		corridor_escape_lamp.visible = false


func _on_CorridorMiddleArea_body_entered(body):
	corridor_middle_lamp.visible = true


func _on_CorridorMiddleArea_body_exited(body):
	corridor_middle_lamp.visible = false


func _on_CorridorRestArea_body_entered(body):
	corridor_rest_lamp.visible = true


func _on_CorridorRestArea_body_exited(body):
	corridor_rest_lamp.visible = false


func _on_FlickerTimer_timeout():
	var emission_enabled = bool(damaged_light_material.emission_energy)
	emission_enabled = not emission_enabled
	if emission_enabled:
		$FlickerSound1.play()
		$FlickerSound2.play()
		damaged_light_material.emission_energy = 0.2
	else:
		damaged_light_material.emission_energy = 0.0
		
	$FlickerTimer.wait_time = randf() * 0.02 + 0.02
	$FlickerTimer.start()


func _on_LongFlickerTimer_timeout():
	flicker_on = not flicker_on
	
	if flicker_on:
		$LongFlickerTimer.wait_time = randf() * 1
		$FlickerTimer.start()
	else:
		damaged_light_material.emission_energy = 0
		$LongFlickerTimer.wait_time = randf() * 0.5 + 0.5
		$FlickerTimer.stop()
	$LongFlickerTimer.start()