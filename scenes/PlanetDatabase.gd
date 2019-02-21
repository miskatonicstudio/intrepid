extends "GamePopup.gd"

const TEXT_PLANET_DATABASE_HEADER = """[color=fuchsia]
	 ____  _                  _   
	|  _ \\| | __ _ _ __   ___| |_ 
	| |_) | |/ _` | '_ \\ / _ \\ __|
	|  __/| | (_| | | | |  __/ |_ 
	|_|   |_|\\__,_|_| |_|\\___|\\__|
	                              
	 ____        _        _                    
	|  _ \\  __ _| |_ __ _| |__   __ _ ___  ___ 
	| | | |/ _` | __/ _` | '_ \\ / _` / __|/ _ \\
	| |_| | (_| | || (_| | |_) | (_| \\__ \\  __/
	|____/ \\__,_|\\__\\__,_|_.__/ \\__,_|___/\\___|

[/color]"""

const PLANETS = {
    '0000': 'Ashorix',
    '0001': 'Pleaziria',
    '0002': 'Meacir',
    '0003': 'Frarth',
    '0010': 'Scion',
    '0011': 'Quehiri',
    '0012': 'Strion',
    '0013': 'Aenus',
    '0020': 'Nainerth',
    '0021': 'Sponoe',
    '0022': 'Crinda',
    '0023': 'Estichi',
    '0030': 'Potrion',
    '0031': 'Scippe',
    '0032': 'Tronoe',
    '0033': 'Plohaliv',
    '0040': 'Riunus',
    '0041': 'Utania',
    '0042': 'Droquos',
    '0043': 'Chapohines',
    '0100': 'Rastumia',
    '0101': 'Asleon',
    '0102': 'Skao',
    '0103': 'Vayrilia',
    '0110': 'Gapreshan',
    '0111': 'Mosmoenia',
    '0112': 'Crippe',
    '0113': 'Astrarth',
    '0120': 'Dremetis',
    '0121': 'Aestea',
    '0122': 'Pryke',
    '0123': 'Sceutis',
    '0130': 'Euruta',
    '0131': 'Snevarus',
    '0132': 'Naphus',
    '0133': 'Aspichi',
    '0140': 'Xecriamia',
    '0141': 'Robloaria',
    '0142': 'Lestretis',
    '0143': 'Oscadus',
    '1000': 'Badrion',
    '1001': 'Griri',
    '1002': 'Xiaphus',
    '1003': 'Theneos',
    '1010': 'Aprouhiri',
    '1011': 'Botadus',
    '1012': 'Opryke',
    '1013': 'Soyrus',
    '1020': 'Yecury',
    '1021': 'Yiaruta',
    '1022': 'Gehorth',
    '1023': 'Stosamia',
    '1030': 'Kiovis',
    '1031': 'Skagua',
    '1032': 'Meuris',
    '1033': 'Cusceus',
    '1040': 'Cillion',
    '1041': 'Tuglilia',
    '1042': 'Aenope',
    '1043': 'Daclides',
    '1100': 'Gubos',
    '1101': 'Zuspara',
    '1102': 'Resteyn',
    '1103': 'Ustruna',
    '1110': 'Sceron',
    '1111': 'Pruolia',
    '1112': 'Mosmyria',
    '1113': 'Greron',
    '1120': 'Iaeter',
    '1121': 'Teaturn',
    '1122': 'Geonides',  # the one
    '1123': 'Cruna',
    '1130': 'Scorix',
    '1131': 'Spart',
    '1132': 'Kearus',
    '1133': 'Oglade',
    '1140': 'Glides',
    '1141': 'Draqua',
    '1142': 'Beolea',
    '1143': 'Fenope',
}

const QUESTIONS = [
    ['Atmosphere', 'No', 'Yes'],
    ['Water', 'No', 'Yes'],
    ['Number of moons', 'Zero', 'One', 'Two', 'Three', 'Four'],
    [
        'Mineral',
        'Vistulum', 'Pulcherium', 'Cotofotelum', 'Triodecennium',
        'Sanescobarium', 'Coroncum', 'Lannisterium', 'Escapium',
        'Miscatonium', 'Obsidium', 'Pragium', 'Pastentomatium'
    ],
]

const LOCK_SCREEN_CODE = '4085'

onready var textbox = $CenterContainer/TextureRect/RichTextLabel
onready var lock_screen = $CenterContainer/TextureRect/LockScreen
onready var lock_screen_stars = [
	$CenterContainer/TextureRect/LockScreen/Stars/LockStar0,
	$CenterContainer/TextureRect/LockScreen/Stars/LockStar1,
	$CenterContainer/TextureRect/LockScreen/Stars/LockStar2,
	$CenterContainer/TextureRect/LockScreen/Stars/LockStar3,
]
onready var stars = $CenterContainer/TextureRect/LockScreen/Stars
onready var underscores = $CenterContainer/TextureRect/LockScreen/Underscores
onready var wrong_code_screen = $CenterContainer/TextureRect/WrongCodeScreen
onready var correct_code_screen = $CenterContainer/TextureRect/CorrectCodeScreen
onready var wrong_code_timer = $WrongCodeTimer
onready var correct_code_timer = $CorrectCodeTimer
onready var show_all_stars_timer = $ShowAllStartTimer
onready var click_sound = $ClickSound
onready var wrong_code_sound = $WrongCodeSound
onready var correct_code_sound = $CorrectCodeSound

var locked = true
var lock_screen_input = ''
var user_answers = []
var current_question_index
var user_input = ""
var program_ended = false

func _ready():
	._ready()
	
	_start_planet_database()


func handle_input_accept():
	if not wrong_code_timer.is_stopped():
		return
	if locked:
		if lock_screen_input == LOCK_SCREEN_CODE:
			stars.hide()
			underscores.hide()
			correct_code_sound.play()
			correct_code_timer.start()
			correct_code_screen.show()
		else:
			wrong_code_sound.play()
			wrong_code_timer.start()
			show_all_stars_timer.start()
		return
	if program_ended:
		_start_planet_database()
		return
	if _user_input_valid():
		user_answers.append(user_input.to_int())
		current_question_index += 1
		if current_question_index >= QUESTIONS.size():
			_print_planet_name()
		else:
			_print_current_question()
	else:
		_print_error_message()
	user_input = ""


func handle_input_backspace():
	if not wrong_code_timer.is_stopped():
		return
	if locked:
		var current_star_index = lock_screen_input.length() - 1
		if current_star_index < 0:
			return
		lock_screen_stars[current_star_index].hide()
		lock_screen_input = lock_screen_input.substr(0, lock_screen_input.length() - 1)
		return
	if user_input.length() > 0:
		pop_text()
		user_input = user_input.substr(0, user_input.length() - 1)


func handle_input_text(text):
	if not (wrong_code_timer.is_stopped() and correct_code_timer.is_stopped()):
		return
	if locked:
		lock_screen_input += text
		var current_star_index = lock_screen_input.length() - 1
		lock_screen_stars[current_star_index].show()
		if lock_screen_input.length() == LOCK_SCREEN_CODE.length():
			handle_input_accept()
		return
	append_text(text, false)
	user_input += text


func append_text(text, indent=true):
	if indent:
		textbox.bbcode_text += '[indent]' + text + '[/indent]'
	else:
		textbox.bbcode_text += text


func print_text(text):
	textbox.bbcode_text = text


func pop_text():
	textbox.bbcode_text = textbox.bbcode_text.substr(0, textbox.bbcode_text.length() - 1)


# PLANET DATABASE METHODS

func _start_planet_database():
	program_ended = false
	user_answers.clear()
	current_question_index = 0
	
	print_text(TEXT_PLANET_DATABASE_HEADER)
	_print_current_question()

func _print_current_question():
	var question = QUESTIONS[current_question_index].duplicate()
	var text_question = question[0]
	var text_answers = ""
	var answers = question
	answers.pop_front()
	for i in range(answers.size()):
		text_answers += "%s: %s, " % [i, answers[i]]
	text_answers.erase(text_answers.length() - 2, 2)
	var text_question_with_answers = "\n%s [%s]:\n" % [text_question, text_answers]
	append_text(text_question_with_answers)
	append_text('')

func _user_input_valid():
	if not user_input.is_valid_integer():
		return false
	return user_input.to_int() < QUESTIONS[current_question_index].size() - 1

func _print_planet_name():
	var planet_key = ""
	var planet_name = ""
	
	if user_answers[3] >= 4:
		var additional_moons = user_answers[3] / 4
		var new_moon_count = (user_answers[2] + additional_moons) % 5
		user_answers[2] = new_moon_count
		user_answers[3] = user_answers[3] % 4
	
	for i in range(user_answers.size()):
		planet_key += str(user_answers[i])
	if planet_key in PLANETS.keys():
		planet_name = PLANETS[planet_key]
	else:
		planet_name = "UNKNOWN"
	append_text("\nThe planet is:\n[color=yellow]%s[/color]\nPress Enter to search again" % planet_name)
	program_ended = true

func _print_error_message():
	append_text("\n[color=red]Incorrect option[/color]\n")
	append_text('')

func _process_screen_click(value, press_button=false):
	var button = null
	var container = $CenterContainer/TextureRect/Container
	
	click_sound.play()
	if value == "accept":
		handle_input_accept()
		button = container.get_node('Enter')
	elif value == "backspace":
		handle_input_backspace()
		button = container.get_node('Cancel')
	else:
		handle_input_text(value)
		if value.is_valid_integer():
			button = container.get_node(value)
	
	if button and press_button:
		button.texture_normal = button.texture_pressed
		$KeyboardInputTimer.start()

func _handle_user_input(event):
	if not $KeyboardInputTimer.is_stopped():
		return
	
	if event is InputEventKey and event.is_pressed():
		if Input.is_action_just_pressed('accept'):
			_process_screen_click('accept', true)
		elif event.scancode == KEY_BACKSPACE:
			_process_screen_click('backspace', true)
		else:
			var input_text = char(event.unicode)
			if input_text != '' and input_text.is_valid_integer():
				_process_screen_click(input_text, true)


func _on_0_button_down():
	_process_screen_click("0")

func _on_1_button_down():
	_process_screen_click("1")

func _on_2_button_down():
	_process_screen_click("2")

func _on_3_button_down():
	_process_screen_click("3")

func _on_4_button_down():
	_process_screen_click("4")

func _on_5_button_down():
	_process_screen_click("5")

func _on_6_button_down():
	_process_screen_click("6")

func _on_7_button_down():
	_process_screen_click("7")

func _on_8_button_down():
	_process_screen_click("8")

func _on_9_button_down():
	_process_screen_click("9")

func _on_Cancel_button_down():
	_process_screen_click("backspace")

func _on_Enter_button_down():
	_process_screen_click("accept")

func _on_WrongCodeTimer_timeout():
	wrong_code_screen.hide()
	underscores.show()

func _on_ShowAllStartTimer_timeout():
	wrong_code_screen.show()
	lock_screen_input = ''
	for star in lock_screen_stars:
		star.hide()
	underscores.hide()

func _on_CorrectCodeTimer_timeout():
	locked = false
	lock_screen.hide()
	correct_code_screen.hide()

func _on_KeyboardInputTimer_timeout():
	for button in $CenterContainer/TextureRect/Container.get_children():
		button.texture_normal = button.texture_hover
