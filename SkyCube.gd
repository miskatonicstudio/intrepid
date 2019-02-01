extends Spatial


export(Texture) var front = null
export(Texture) var right = null
export(Texture) var back = null
export(Texture) var left = null
export(Texture) var up = null
export(Texture) var down = null


func _ready():
	var mesh = $Mesh
	var textures = [back, front, left, up, right, down]
	
	for i in range(6):
		var material = SpatialMaterial.new()
		material.flags_unshaded = true
		material.render_priority = 2
		material.albedo_texture = textures[i]
		mesh.set_surface_material(i, material)