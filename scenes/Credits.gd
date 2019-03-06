extends Container

var credits = [
	'Coding:\n\nPaweł Fertyk\nStanisław Karlik',
	'Testing:\n\nAndy Bohan\nPedro "Rocket Lawnchair" Blandino\nKalrirr\nBernard Klatka',
	'Game assets:\n\nZaven Alexander Boyrazian',
	'Logo design:\n\nJoseph Diaz',
	'Special thanks to:\n\nWiś'
]
onready var label = $CenterContainer/Label
onready var credits_timer = $CreditsDelayTimer
onready var music_mute_timer = $MusicMuteTimer
onready var tween = $Tween
onready var sound = $Sound


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	tween.start()
	show_current_credits()


func show_current_credits():
	if len(credits) == 0:
		credits_timer.stop()
		tween.interpolate_method(
			self, "set_sound_volume", sound.volume_db, -50,
			music_mute_timer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		music_mute_timer.start()
	else:
		var current_credits = credits.pop_front()
		label.text = current_credits
		tween.interpolate_method(
			self, "set_label_visibility", 0, 1,
			credits_timer.wait_time*0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0
		)
		tween.interpolate_method(
			self, "set_label_visibility", 1, 0,
			credits_timer.wait_time*0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT, credits_timer.wait_time*0.75
		)


func set_label_visibility(visibility):
	label.self_modulate.a = visibility


func set_sound_volume(volume):
	sound.volume_db = volume


func _unhandled_input(event):
	if Input.is_action_just_pressed('skip'):
		go_to_main()


func go_to_main():
	global.goto_scene('res://scenes/MainScreen.tscn')


func _on_CreditsDelayTimer_timeout():
	show_current_credits()


func _on_MusicMuteTimer_timeout():
	go_to_main()
