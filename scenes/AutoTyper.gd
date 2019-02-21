extends Label

export (String) var raw_output = '1;hello there;3';
export (Array) var console_output = []
export (bool) var autostart = true;
signal finished_typing

onready var label = $"."
onready var cursor_blink_timer = $CursorBlinkTimer
onready var pause_timer = $PauseTimer
onready var char_typing_timer = $CharTypingTimer
onready var font = $".".get_font("font")

var current_output_text = '█'
var cursor_visible = true
var current_char_index = 0
var current_output_index = 0


func _ready():
	update_console(current_output_text)
	console_output = raw_output.split(';')
	if autostart:
		start_line_processing()


func start_line_processing():
	if current_output_index >= len(console_output):
		emit_signal("finished_typing")
		return
	var pause_time = float(console_output[current_output_index])
	if pause_time == 0:
		pause_timer.emit_signal("timeout")
		return
	pause_timer.wait_time = pause_time
	toggle_cursor()
	cursor_blink_timer.start()
	pause_timer.start()


func toggle_cursor():
	if cursor_visible:
		update_console(current_output_text)
	else:
		update_console(current_output_text.substr(0, len(current_output_text) - 1))
	cursor_visible = not cursor_visible


func update_console(text):
	label.text = text


func insert_char(character):
	current_output_text = current_output_text.insert(len(current_output_text) - 1, character)
	update_console(current_output_text)


func _on_CursorBlinkTimer_timeout():
	toggle_cursor()


func _on_PauseTimer_timeout():
	pause_timer.stop()
	cursor_blink_timer.stop()
	cursor_visible = true
	if current_output_index + 1 >= len(console_output):
		emit_signal("finished_typing")
		return
	current_output_index += 1
	current_char_index = 0
	var line = console_output[current_output_index]
	char_typing_timer.start()


func _on_CharTypingTimer_timeout():
	$Sound.play()
	var current_line = console_output[current_output_index]
	if current_char_index >= len(current_line):
		char_typing_timer.stop()
		current_output_index += 1
		start_line_processing()
	else:
		var character = current_line[current_char_index]
		insert_char(character)
		current_char_index += 1
