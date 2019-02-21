extends StaticBody

signal activated

onready var surface = $ScreenSurface

func _ready():
#	surface.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	if surface.material_override:
		surface.material_override.emission_enabled = true
#		surface.material_override.flags_unshaded = true

func set_screen(img):
	surface.material_override = surface.material_override.duplicate()
	if surface.material_override:
		surface.material_override.albedo_texture = img
		surface.material_override.emission_texture = img