extends Spatial

var rest_of_spaceship = preload('res://scenes/RestOfSpaceship.tscn')


func _ready():
	global.connect('player_died', self, '_on_player_died')
	global.connect('player_escaped', self, '_on_player_escaped')
	global.connect('gameplay_started', self, '_on_gameplay_started')
	
	global._on_shadows_changed(global.shadows_enabled)
#	var lamps = get_tree().get_nodes_in_group('lamps')
#	for lamp in lamps:
#		lamp.shadow_enabled = global.shadows_enabled
#		lamp.light_specular = 0.5 if global.shadows_enabled else 0.0


func _on_gameplay_started(camera):
	add_child(rest_of_spaceship.instance())


func _on_player_died():
	global.survived = false
	global.goto_scene('res://scenes/GameOutro.tscn')


func _on_player_escaped():
	global.survived = true
	global.goto_scene('res://scenes/GameOutro.tscn')