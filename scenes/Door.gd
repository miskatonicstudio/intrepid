extends Spatial

export (bool) var active = true

const opening_time = 0.2

onready var tween = $Tween
onready var door_left = $Door01L
onready var door_right = $Door01R
var door_left_pos_closed
var door_left_pos_open
var door_right_pos_closed
var door_right_pos_open


func _ready():
	door_left_pos_closed = door_left.translation
	door_left_pos_open = door_left_pos_closed + Vector3(0, 0, 1)
	
	door_right_pos_closed = door_right.translation
	door_right_pos_open = door_right_pos_closed + Vector3(0, 0, -1)
	
	var emission_color = Color(0.2, 0.8, 0.9) if active else Color(0.9, 0.2, 0.2)
	
	var material = door_left.get_node("Model").get_surface_material(0).duplicate(true)
	material.emission = emission_color
	material.emission_energy = 4
	
	for door in [door_left, door_right]:
		door.get_node("Model").set_surface_material(0, material)


func _on_Area_body_entered(body):
	if active:
		tween.interpolate_property(
			door_left, "translation", door_left_pos_closed, door_left_pos_open,
			opening_time, Tween.TRANS_SINE, Tween.EASE_IN
		)
		tween.interpolate_property(
			door_right, "translation", door_right_pos_closed, door_right_pos_open,
			opening_time, Tween.TRANS_SINE, Tween.EASE_IN
		)
		tween.start()
		$OpenSound.play()


func _on_Area_body_exited(body):
	if active:
		tween.interpolate_property(
			door_left, "translation", door_left_pos_open, door_left_pos_closed,
			opening_time, Tween.TRANS_SINE, Tween.EASE_IN
		)
		tween.interpolate_property(
			door_right, "translation", door_right_pos_open, door_right_pos_closed,
			opening_time, Tween.TRANS_SINE, Tween.EASE_IN
		)
		tween.start()
		$CloseSound.play()
