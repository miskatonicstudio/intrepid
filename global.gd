extends Node

var survived = false
var camera_is_shaking = false
var overload_timer = Timer.new()
var current_scene = null

signal code_binder_acquired
signal code_page_acquired
signal planet_database_acquired
signal tablet_acquired

signal shake_camera (intensity, is_final)
signal gameplay_started
signal player_died
signal player_escaped
signal escape_door_available
signal start_opening_escape_door
signal escape_door_open

# These signals continue to disappear from normal scenes (bug), co I've put them here
signal drawer_unlocked
signal power_panel_unlocked
signal emergency_screen_closed

# Settings flags
onready var env = load(ProjectSettings.get_setting('rendering/environment/default_environment'))
const settings_file_path = "user://Intrepid_settings.cfg"
var settings_file = null
var shadows_enabled = true
var fullscreen_enabled = true
var glow_enabled = true
var reflections_enabled = true
var music_volume = 0
var effects_volume = 0
var mouse_sensitivity = 0.3
signal mouse_sensitivity_changed (value)
signal music_volume_changed (value)
signal effects_volume_changed (value)
signal fullscreen_changed (value)
signal glow_changed (value)
signal reflections_changed (value)
signal shadows_changed (value)


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
	overload_timer.wait_time = 60 * 60
	overload_timer.one_shot = true
	overload_timer.autostart = false
	add_child(overload_timer)
	connect('shake_camera', global, 'disable_player_interaction')
	connect('gameplay_started', global, 'start_overload_timer')
	connect('escape_door_available', global, 'stop_overload_timer')
	
	connect('mouse_sensitivity_changed', global, '_on_mouse_sensitivity_changed')
	connect('music_volume_changed', global, '_on_music_volume_changed')
	connect('effects_volume_changed', global, '_on_effects_volume_changed')
	connect('fullscreen_changed', global, '_on_fullscreen_changed')
	connect('glow_changed', global, '_on_glow_changed')
	connect('reflections_changed', global, '_on_reflections_changed')
	connect('shadows_changed', global, '_on_shadows_changed')
	
	settings_file = ConfigFile.new()
	var err = settings_file.load(settings_file_path)
	if err != OK:
		print('Settings file not found!')
	
	fullscreen_enabled = settings_file.get_value('graphics', 'fullscreen', true)
	glow_enabled = settings_file.get_value('graphics', 'glow', true)
	reflections_enabled = settings_file.get_value('graphics', 'reflections', true)
	shadows_enabled = settings_file.get_value('graphics', 'shadows', true)
	music_volume = settings_file.get_value('sound', 'music', 0)
	effects_volume = settings_file.get_value('sound', 'effects', 0)
	mouse_sensitivity = settings_file.get_value('controls', 'mouse_sensitivity', 0.3)
	
	if err != OK:
		save_settings()
	
	_on_fullscreen_changed(fullscreen_enabled)
	_on_glow_changed(glow_enabled)
	_on_reflections_changed(reflections_enabled)
	_on_music_volume_changed(music_volume)
	_on_effects_volume_changed(effects_volume)
	_on_mouse_sensitivity_changed(mouse_sensitivity)

func save_settings():
	settings_file.set_value('graphics', 'fullscreen', fullscreen_enabled)
	settings_file.set_value('graphics', 'glow', glow_enabled)
	settings_file.set_value('graphics', 'reflections', reflections_enabled)
	settings_file.set_value('graphics', 'shadows', shadows_enabled)
	settings_file.set_value('sound', 'music', music_volume)
	settings_file.set_value('sound', 'effects', effects_volume)
	settings_file.set_value('controls', 'mouse_sensitivity', mouse_sensitivity)
	
	settings_file.save(settings_file_path)


func _on_mouse_sensitivity_changed(value):
	mouse_sensitivity = value
	save_settings()


func _on_music_volume_changed(value):
	var bus_id = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_volume_db(bus_id, value)
	music_volume = value
	save_settings()


func _on_effects_volume_changed(value):
	var bus_id = AudioServer.get_bus_index('Effects')
	AudioServer.set_bus_volume_db(bus_id, value)
	effects_volume = value
	save_settings()


func _on_shadows_changed(value):
	shadows_enabled = value
	
	var lamps = get_tree().get_nodes_in_group('lamps')
	for lamp in lamps:
		lamp.shadow_enabled = shadows_enabled
		lamp.light_specular = 0.5 if shadows_enabled else 0.0
	
	save_settings()


func _on_glow_changed(value):
	glow_enabled = value
	env.glow_enabled = glow_enabled
	save_settings()


func _on_reflections_changed(value):
	reflections_enabled = value
	env.ss_reflections_enabled = reflections_enabled
	save_settings()


func _on_fullscreen_changed(value):
	fullscreen_enabled = value
	OS.window_fullscreen = fullscreen_enabled

	if not OS.window_fullscreen:
		OS.window_size = Vector2(
			ProjectSettings.get_setting('display/window/size/width'),
			ProjectSettings.get_setting('display/window/size/height')
		)
	
	save_settings()


func disable_player_interaction(intensity, is_final):
	camera_is_shaking = true
	var popups = get_tree().get_nodes_in_group('popups')
	var popups_visible = false
	for popup in popups:
		if popup.visible:
			popups_visible = true
			break
	if popups_visible:
		for popup in popups:
			popup.hide_with_cursor()


func start_overload_timer(camera):
	overload_timer.start()


func stop_overload_timer():
	overload_timer.stop()


func hide_all_popups():
	var popups = get_tree().get_nodes_in_group('popups')
	for popup in popups:
		popup.hide()


func goto_scene(path):
	call_deferred('_deferred_goto_scene', path)


func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
