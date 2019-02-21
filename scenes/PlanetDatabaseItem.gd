extends HBoxContainer

func _ready():
	global.connect("planet_database_acquired", self, "_on_planet_database_acquired")

func _on_planet_database_acquired():
	visible = true
