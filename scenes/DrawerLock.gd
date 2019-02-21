extends "GamePopup.gd"

const COMBINATION = [0, 1, 1, 0, 1, 0, 0, 1]

var current_combination = [0, 0, 0, 0, 0, 0, 0, 0]


func _toggle_number(number):
	$Click.play()
	var index = number - 1
	var current_value = current_combination[index]
	var new_value = 0 if current_value else 1
	current_combination[index] = new_value
	if current_combination == COMBINATION:
		$Unlock.play()


func _on_1_toggled(button_pressed):
	_toggle_number(1)


func _on_2_toggled(button_pressed):
	_toggle_number(2)


func _on_3_toggled(button_pressed):
	_toggle_number(3)


func _on_4_toggled(button_pressed):
	_toggle_number(4)


func _on_5_toggled(button_pressed):
	_toggle_number(5)


func _on_6_toggled(button_pressed):
	_toggle_number(6)


func _on_7_toggled(button_pressed):
	_toggle_number(7)


func _on_8_toggled(button_pressed):
	_toggle_number(8)


func _on_Unlock_finished():
	global.emit_signal('drawer_unlocked')
	self.hide_with_cursor()
	self.queue_free()
