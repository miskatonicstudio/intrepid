extends Spatial

onready var escape_spot_1_light = $EscapePodSpotLight1
onready var escape_spot_2_light = $EscapePodSpotLight2


func _ready():
	global.connect('escape_door_available', self, '_on_escape_door_available')


func _on_escape_door_available():
	escape_spot_1_light.show()
	escape_spot_2_light.show()