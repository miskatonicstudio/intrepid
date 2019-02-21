extends "GamePopup.gd"

const COMBINATION = '0829125'
const RED = Color('#db8484')
const GREEN = Color('#97ef4f')
const BLUE = Color('#94e2fc')

onready var background = $Container/Background
onready var keypad_locked = $Container/KeypadLocked
onready var keypad_unlocked = $Container/KeypadUnlocked

var current_combination = ''


func _enter_number(number):
	if $Wrong.is_playing() or $Correct.is_playing():
		return
	
	$Click.play()
	current_combination += str(number)
	if len(current_combination) == len(COMBINATION):
		if current_combination == COMBINATION:
			keypad_unlocked.show()
			keypad_locked.hide()
			background.color = GREEN
			$Timer.start()
			$Correct.play()
		else:
			background.color = RED
			$Wrong.play()


func _on_Wrong_finished():
	current_combination = ''
	background.color = BLUE


func _on_Correct_finished():
	self.hide_with_cursor()
	global.emit_signal('power_panel_unlocked')


func _handle_user_input(event):
	if event is InputEventKey and event.is_pressed():
		var input_text = char(event.unicode)
		if input_text != '' and input_text.is_valid_integer():
			_enter_number(int(input_text))


func _on_1_button_down():
	_enter_number(1)


func _on_2_button_down():
	_enter_number(2)


func _on_3_button_down():
	_enter_number(3)


func _on_4_button_down():
	_enter_number(4)


func _on_5_button_down():
	_enter_number(5)


func _on_6_button_down():
	_enter_number(6)


func _on_7_button_down():
	_enter_number(7)


func _on_8_button_down():
	_enter_number(8)


func _on_9_button_down():
	_enter_number(9)


func _on_0_button_down():
	_enter_number(0)


func _on_Timer_timeout():
	background.color = BLUE
	keypad_unlocked.hide()
	keypad_locked.show()
