extends HBoxContainer

func _ready():
	global.connect("tablet_acquired", self, "_on_tablet_acquired")

func _on_tablet_acquired():
	visible = true
