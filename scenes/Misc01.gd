extends Spatial

onready var cryo_middle_lamp = $CryoMiddleLamp
onready var cryo_far_lamp = $CryoFarLamp


func _ready():
	cryo_far_lamp.visible = true
	cryo_middle_lamp.visible = true


func _on_CryoArea_body_entered(body):
	cryo_far_lamp.visible = true
	cryo_middle_lamp.visible = true


func _on_CryoArea_body_exited(body):
	cryo_far_lamp.visible = false
	cryo_middle_lamp.visible = false
