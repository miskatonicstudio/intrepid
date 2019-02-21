extends "res://scenes/InteractiveCube.gd"


export (AudioStream) var sound


func _ready():
	._ready()
	$Sound.stream = self.sound


func _on_InteractiveInventoryCube_activated():
	self.collision_layer = 4
	self.get_node('Model').queue_free()
	$Sound.play()

func _on_Sound_finished():
	self.queue_free()
