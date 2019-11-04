extends "GamePopup.gd"

var PLANET_TEXTURES = []
var NOTES_TEXTURES = []
var PLANET_SIZE_X = null
var PLANET_SIZE_Y = null
var INITIAL_BAR_POS_Y = null
const BAR_SWIPE_OFFSET = 100
const BAR_HEIGHT = 40
const PLANET_NAMES = [
	'Fungal', 'GasGiant', 'Wasteland', 'Ice', 'Martian', 'Storm', 'Volcanic'
]

var initial_swipe_x_pos = null
var current_planet_id = 0
var bar_initial_swipe_y_pos = null
var notes_enabled = false

onready var left_split = $CenterContainer/ScreenSurface/HBoxContainer/LeftSplit
onready var middle_split = $CenterContainer/ScreenSurface/HBoxContainer/MiddleSplit
onready var right_split = $CenterContainer/ScreenSurface/HBoxContainer/RightSplit
onready var left_notes = $CenterContainer/ScreenSurface/HBoxContainer/Container/LeftNotes
onready var middle_notes = $CenterContainer/ScreenSurface/HBoxContainer/Container/MiddleNotes
onready var right_notes = $CenterContainer/ScreenSurface/HBoxContainer/Container/RightNotes
onready var notes = $CenterContainer/ScreenSurface/HBoxContainer/Container
onready var screen_splits_container = $CenterContainer/ScreenSurface/HBoxContainer
onready var screen_surface = $CenterContainer/ScreenSurface
onready var settings_background = $CenterContainer/ScreenWithBar/SettingsBackground
onready var wifi_button = $CenterContainer/ScreenWithBar/SettingsBackground/HBoxContainer/WiFiButton
onready var gps_button = $CenterContainer/ScreenWithBar/SettingsBackground/HBoxContainer/GpsButton
onready var pen_button = $CenterContainer/ScreenWithBar/SettingsBackground/HBoxContainer/PenButton
onready var tween = $Tween
onready var timer = $Timer

func _ready():
	._ready()
	var texture_folder = "res://images"
	var planet_texture_string = "%s/Tablet_%s.png"
	var notes_texture_string = "%s/Tablet_%s_notes.png"
	for planet_name in PLANET_NAMES:
		PLANET_TEXTURES.append(load(planet_texture_string % [texture_folder, planet_name]))
		NOTES_TEXTURES.append(load(notes_texture_string % [texture_folder, planet_name]))
	
	PLANET_SIZE_X = PLANET_TEXTURES[0].get_width()
	PLANET_SIZE_Y = PLANET_TEXTURES[0].get_height()
	left_split.position.x = 0
	left_notes.position.x = 0
	middle_split.position.x = PLANET_SIZE_X
	middle_notes.position.x = PLANET_SIZE_X
	right_split.position.x = 2 * PLANET_SIZE_X
	right_notes.position.x = 2 * PLANET_SIZE_X
	INITIAL_BAR_POS_Y = BAR_HEIGHT - PLANET_SIZE_Y
	
	_show_planets()
	_set_splits_delta(0)
	settings_background.rect_position.y = INITIAL_BAR_POS_Y
	for button in [wifi_button, gps_button, pen_button]:
		_toggle_button(button)

func _wrap_planet_id(planet_index):
	return wrapi(planet_index, 0, len(PLANET_NAMES))

func _show_planets():
	left_split.texture = PLANET_TEXTURES[_wrap_planet_id(current_planet_id - 1)]
	middle_split.texture = PLANET_TEXTURES[current_planet_id]
	right_split.texture = PLANET_TEXTURES[_wrap_planet_id(current_planet_id + 1)]
	left_notes.texture = NOTES_TEXTURES[_wrap_planet_id(current_planet_id - 1)]
	middle_notes.texture = NOTES_TEXTURES[current_planet_id]
	right_notes.texture = NOTES_TEXTURES[_wrap_planet_id(current_planet_id + 1)]

func _on_ScreenSurface_gui_input(ev):
	if not timer.is_stopped():
		return
	var mouse_pos = get_global_mouse_position()
	var swipe_delta = mouse_pos.x - initial_swipe_x_pos if initial_swipe_x_pos != null else null
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		if ev.pressed:
			initial_swipe_x_pos = mouse_pos.x
		elif initial_swipe_x_pos != null:
			_end_swipe_action(swipe_delta)
	elif ev is InputEventMouseMotion and initial_swipe_x_pos != null:
		if screen_surface.get_rect().has_point(mouse_pos):
			_set_splits_delta(swipe_delta)
		else:
			_end_swipe_action(swipe_delta)

func _end_swipe_action(swipe_delta):
	var target_delta = 0
	if swipe_delta <= -PLANET_SIZE_X/2:
		target_delta = -PLANET_SIZE_X
	elif swipe_delta >= PLANET_SIZE_X/2:
		target_delta = PLANET_SIZE_X
	var wait_time = 0.7 * (1 - abs(swipe_delta)/PLANET_SIZE_X)
	tween.interpolate_method(
		self, "_set_splits_delta", swipe_delta, target_delta, wait_time, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	tween.start()
	timer.wait_time = wait_time
	timer.start()
	initial_swipe_x_pos = null

func _set_splits_delta(delta):
	screen_splits_container.rect_position = Vector2(-PLANET_SIZE_X + delta, 0)
	
func _get_splits_delta():
	return screen_splits_container.rect_position.x + PLANET_SIZE_X

func _on_Tween_tween_completed(object, key):
	var splits_delta = _get_splits_delta()
	if splits_delta != 0:
		if splits_delta < 0:
			current_planet_id = _wrap_planet_id(current_planet_id + 1)
		elif splits_delta > 0:
			current_planet_id = _wrap_planet_id(current_planet_id - 1)
		_show_planets()
		_set_splits_delta(0)

func _on_SettingsBackground_gui_input(ev):
	if not timer.is_stopped():
		return
	var mouse_pos = get_global_mouse_position()
	if ev is InputEventMouseButton:
		if ev.pressed:
			if settings_background.rect_position.y == 0:
				_end_bar_swipe(0)
			else:
				bar_initial_swipe_y_pos = mouse_pos.y
		elif bar_initial_swipe_y_pos != null:
			_end_bar_swipe(mouse_pos.y - bar_initial_swipe_y_pos)
	elif ev is InputEventMouseMotion and bar_initial_swipe_y_pos != null:
		var bar_swipe = max(0, mouse_pos.y - bar_initial_swipe_y_pos)
		if screen_surface.get_rect().has_point(mouse_pos):
			settings_background.rect_position.y = INITIAL_BAR_POS_Y + bar_swipe
		else:
			_end_bar_swipe(min(mouse_pos.y, screen_surface.get_rect().size.y) - bar_initial_swipe_y_pos)

func _end_bar_swipe(swipe_delta):
	var target_delta = 0 if swipe_delta >= BAR_SWIPE_OFFSET else INITIAL_BAR_POS_Y
	var wait_time = 0.25
	tween.interpolate_property(
		settings_background, "rect_position", settings_background.rect_position, Vector2(0, target_delta),
		wait_time, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	tween.start()
	timer.wait_time = wait_time
	timer.start()
	bar_initial_swipe_y_pos = null

func _on_WiFiButton_toggled(button_pressed):
	_toggle_button(wifi_button)

func _on_GpsButton_toggled(button_pressed):
	_toggle_button(gps_button)
	
func _on_PenButton_toggled(button_pressed):
	_toggle_button(pen_button)
	notes.visible = button_pressed

func _toggle_button(button):
	if button.pressed:
		button.modulate = Color(1, 1, 1)
	else:
		button.modulate = Color(0.5, 0.5, 0.5)
