extends StaticBody

signal activated

export (bool) var one_time = false
export (bool) var raycast_enabled = true


func _ready():
	if not raycast_enabled:
		self.collision_layer = 4


func enable_raycast():
	self.raycast_enabled = true
	self.collision_layer = 2

func _on_InteractiveCube_activated():
	if one_time:
		queue_free()