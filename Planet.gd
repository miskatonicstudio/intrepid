extends Spatial


func set_texture(texture):
	var material = load('res://planet.material').duplicate()
	material.albedo_texture = texture
	$Mesh.set_surface_material(0, material)