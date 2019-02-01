extends KinematicBody

export (float) var MOUSE_SENSITIVITY
export (float) var SPEED
export (bool) var active = true

var dir = Vector3()
var collider = null
var step = 'right'

onready var camera = $Camera
onready var tween = $Tween
onready var camera_ray = $Camera/RayCast
onready var left_step_sound = $Camera/LeftStepSound
onready var right_step_sound = $Camera/RightStepSound
onready var steps_timer = $StepsTimer
onready var scope = $Scope
onready var active_scope = $Scope/Label
onready var shaking_timer = $ShakingTimer


func _ready():
	self.MOUSE_SENSITIVITY = global.mouse_sensitivity
	tween.start()
	randomize()
	global.connect('shake_camera', self, 'shake_camera')
	global.connect('escape_door_available', self, 'queue_free') # TODO: make sure that player is available for animation
	global.connect('gameplay_started', self, '_on_gameplay_started')
	global.connect('mouse_sensitivity_changed', self, '_on_mouse_sensitivity_changed')
	if active:
		activate()
	_add_planet(load('res://planet.png'), -60, -25, 50, 0)
	_add_planet(load('res://blue_moon.png'), -80, 10, 1, 0)
	_add_planet(load('res://gray_moon.png'), -85, -10, 0.9, 0)


func _on_mouse_sensitivity_changed(value):
	self.MOUSE_SENSITIVITY = value


func _process(delta):
	if active:
		self.translation.y = 0


func _on_gameplay_started(camera):
	translation.x = camera.translation.x
	translation.z = camera.translation.z
	activate()


func activate():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scope.show()
	active = true
	camera.make_current()


func _add_planet(texture, horizontal_angle=0, vertical_angle=0, scale=1, z_angle=0):
	var root = $'.'
	var planet = load('res://Planet.tscn').instance()
	planet.set_texture(texture)
	planet.rotation_degrees.y = horizontal_angle
	planet.rotation_degrees.z = z_angle
	planet.rotation_degrees.x = vertical_angle
	planet.translate(Vector3(0, 0, -50))
	planet.scale = Vector3(scale, scale, scale)
	root.add_child(planet)


func _input(event):
	dir = Vector3()
	
	if not active:
		return
	if global.camera_is_shaking or Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		camera.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		_rotate_camera_vertically(-event.relative.y * MOUSE_SENSITIVITY)
		_find_collider()
	
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	if Input.is_action_pressed('movement_forward'):
		input_movement_vector.y += 1
	if Input.is_action_pressed('movement_backward'):
		input_movement_vector.y -= 1
	if Input.is_action_pressed('movement_left'):
		input_movement_vector.x -= 1
	if Input.is_action_pressed('movement_right'):
		input_movement_vector.x = 1
	
	input_movement_vector = input_movement_vector.normalized()
	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	dir.y = 0
	dir = dir.normalized()
	
	if Input.is_action_just_pressed('accept') and collider:
		Input.action_release('accept')
		collider.emit_signal('activated')


func _rotate_camera_vertically(angle):
	var camera_rot = camera.rotation_degrees
	camera_rot.x += angle
	camera_rot.x = clamp(camera_rot.x, -80, 80)
	camera.rotation_degrees = camera_rot


func shake_camera(intensity, is_final):
	var start_shake = intensity * 5
	var end_shake = start_shake if is_final else 0
	var time = $CameraShakingTimer.final_shake_sec if is_final else intensity * 4
	
	tween.interpolate_method(
		self, '_randomize_camera_angle', start_shake, end_shake, time,
		Tween.TRANS_SINE, Tween.EASE_IN
	)
	shaking_timer.wait_time = time
	shaking_timer.start()


func _randomize_camera_angle(strength):
	var angle_x = randf() * strength
	var angle_y = randf() * strength
	if randi() % 2 == 1:
		angle_x *= -1
	if randi() % 2 == 1:
		angle_y *= -1
	camera.rotate_y(deg2rad(angle_y))
	_rotate_camera_vertically(angle_x)


func _physics_process(delta):
	if not active:
		return
	_find_collider()
	if dir:
		move_and_slide(dir * SPEED, Vector3(0, 1, 0))
		if steps_timer.is_stopped():
			steps_timer.start()
			_play_step_sound()
	else:
		steps_timer.stop()


func _find_collider():
	collider = null
	if camera_ray.is_colliding():
		var camera_collider = camera_ray.get_collider()
		if not camera_collider:
			return
		var script = camera_collider.get_script()
		if (
			(script and script.has_script_signal('activated')) or
			camera_collider.has_user_signal('activated')
		):
			collider = camera_collider
	if collider and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		active_scope.show()
	else:
		active_scope.hide()


func _on_StepSoundTimer_timeout():
	_play_step_sound()


func _play_step_sound():
	if step == 'right':
		right_step_sound.play()
		step = 'left'
	else:
		left_step_sound.play()
		step = 'right'


func _on_ShakingTimer_timeout():
	global.camera_is_shaking = false
