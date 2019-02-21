extends "GameViewportPopup.gd"

const TEXT_SECURITY_SYSTEM_HEADER = """[color=yellow]	 ____                       _ _              ____            _                 
	/ ___|  ___  ___ _   _ _ __(_) |_ _   _     / ___| _   _ ___| |_ ___ _ __ ___  
	\\___ \\ / _ \\/ __| | | | '__| | __| | | |    \\___ \\| | | / __| __/ _ \\ '_ ` _ \\ 
	 ___) |  __/ (__| |_| | |  | | |_| |_| |     ___) | |_| \\__ \\ ||  __/ | | | | |
	|____/ \\___|\\___|\\__,_|_|  |_|\\__|\\__, |    |____/ \\__, |___/\\__\\___|_| |_| |_|
	                                  |___/            |___/
[/color]"""

const TEXT_ERROR = """
[color=red]
	 _____ ____  ____   ___  ____  
	| ____|  _ \\|  _ \\ / _ \\|  _ \\ 
	|  _| | |_) | |_) | | | | |_) |
	| |___|  _ <|  _ <| |_| |  _ < 
	|_____|_| \\_\\_| \\_\\\\___/|_| \\_\\
[/color]"""

const TEXT_SECURITY_CODE = """
[color=lime]
	____     _  _ _____ _____     ____
	\\ \\ \\   | || |___  |___ /    / / /
	 \\ \\ \\  | || |_ / /  |_ \\   / / / 
	 / / /  |__   _/ /  ___) |  \\ \\ \\ 
	/_/_/      |_|/_/  |____/    \\_\\_\\
[/color]"""

const PASSWORDS = {
    'green': {
        'PWXGAB': '048251',
        'CTZQYK': '072158',
        'BQRGWL': '670145',
        'PUZGCY': '724130',
        'VAPUEK': '152703',
        'WIQNKP': '162495',
        'ECXQFR': '912374',
        'MXSLEZ': '943725',
        'UIVMPH': '387914',
        'GOTCRD': '693180'
    },
    'fuchsia': {
        'SVUDJG': '153047',
        'TDVOMX': '493157',
        'JMNYSC': '250476',
        'UZYITH': '849607',
        'TJDFCR': '172380',
        'ETQJUO': '106584',
        'COTUJP': '459610',
        'IXOMFK': '163804',
        'SPIAHV': '561294',
        'QMOFIH': '023918'
    },
    'aqua': {
        'XQFWES': '193082',
        'PHWMQS': '261948',
        'LGRYCZ': '816492',
        'FVTKZJ': '752861',
        'SQTXRO': '917256',
        'YFLQEB': '579432',
        'EXNGBU': '329547',
        'ETGUOP': '613289',
        'KTHNJE': '263975',
        'GZYDVS': '049875'
    },
    'blue': {
        'OJPKNE': '053714',
        'MGCDTE': '682075',
        'TDESXW': '617039',
        'CLMTNQ': '457312',
        'VGUINM': '796341',
        'YRHVLS': '527481',
        'SOAYQH': '678530',
        'TLBUYO': '973218',
        'HNIAOR': '219645',
        'DNSAXK': '068753'
    },
    'yellow': {
        'HUFMVN': '253071',
        'VNUCPS': '643702',
        'GCEJOH': '127439',
        'QKXRTP': '487132',
        'PUKLHD': '716982',
        'QMXUAV': '704123',
        'XIMFUK': '142705',
        'JUYHOD': '198630',
        'SOPYZA': '649025',
        'TJMLYA': '962145'
    },
    'maroon': {
        'DULQZV': '534917',
        'KHJUWO': '809342',
        'QZVKCI': '739052',
        'WHLJOX': '364128',
        'NGDRQC': '365270',
        'HWJUND': '304825',
        'QEFNTG': '407285',
        'RKLAZT': '419678',
        'VGHUJX': '154978',
        'JIDYVU': '402568'
    }
}
const MAX_USER_INPUT_LENGTH = 20

var textbox
var error_flash_timer

var chosen_passwords = []
var current_password_index
var user_answers = []
var current_bbcode
var current_bbcode_with_error
var error_flashes_left
var user_input_enabled = false
var user_input = ""

func _ready():
	._ready()
	_get_viewport_node().size = Vector2(851, 467)
	randomize()
	
	textbox = $Viewport/RichTextLabel
	error_flash_timer = $ErrorFlashTimer
	
	_start_security_system()

func set_led_color(color):
	$Frame/LED.self_modulate = color

func set_monitor_active(is_active):
	if is_active:
		_get_viewport_node().set_size_override(false)
	else:
		_get_viewport_node().set_size_override(true, Vector2(0, 0))

func _get_viewport_node():
	return $Viewport

func _get_screen_node():
	return $CenterContainer/TextureRect

func _handle_user_input(event):
	if not user_input_enabled:
		return
	
	elif Input.is_action_just_pressed("accept"):
		user_input_enabled = false
		user_answers.append(user_input)
		user_input = ""
		if current_password_index >= chosen_passwords.size():
			_check_answers()
		else:
			_print_password()
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_BACKSPACE:
			if user_input.length() > 0:
				textbox.bbcode_text = textbox.bbcode_text.substr(0, textbox.bbcode_text.length() - 1)
				user_input = user_input.substr(0, user_input.length() - 1)
		else:
			var input_text = char(event.unicode)
			if input_text != "" and len(user_input) < MAX_USER_INPUT_LENGTH:
				textbox.bbcode_text += input_text
				user_input += input_text

# SECURITY SYSTEM METHODS

func _start_security_system():
	_print_header()
	_choose_random_passwords()
	_print_password()

func _print_header():
	textbox.bbcode_text = TEXT_SECURITY_SYSTEM_HEADER

func _choose_random_passwords():
	user_answers.clear()
	chosen_passwords.clear()
	current_password_index = 0
	
	var available_colors = PASSWORDS.keys()
	available_colors.erase("yellow")
	
	for i in range(3):
		var chosen_color = available_colors[randi() % available_colors.size()]
		available_colors.erase(chosen_color)
		_choose_password_with_color(chosen_color)
	_choose_password_with_color("yellow")

func _choose_password_with_color(chosen_color):
	var color_codes = PASSWORDS[chosen_color].keys()
	var chosen_code = color_codes[randi() % color_codes.size()]
	
	chosen_passwords.append(
		{ "color": chosen_color, "code": chosen_code, "answer": PASSWORDS[chosen_color][chosen_code] }
	)

func _print_password():
	var password = chosen_passwords[current_password_index]
	textbox.bbcode_text += "\n"
	textbox.bbcode_text += "\n"
	textbox.bbcode_text += "	[color=" + password["color"] + "]" + "████  "+ password["code"] + ":[/color] "
	user_input_enabled = true
	current_password_index += 1
	

func _check_answers():
	var correct_answers = []
	for password in chosen_passwords:
		correct_answers.append(password['answer'])
	
	if user_answers == correct_answers:
		textbox.bbcode_text += TEXT_SECURITY_CODE
	else:
		_print_error_message()

func _print_error_message():
#	textbox.bbcode_text += TEXT_SECURITY_CODE
#	return
	current_bbcode = textbox.bbcode_text
	current_bbcode_with_error = current_bbcode + TEXT_ERROR
	
	textbox.bbcode_text = current_bbcode_with_error
	error_flashes_left = 6
	error_flash_timer.start()

func _on_ErrorFlashTimer_timeout():
	error_flashes_left -= 1
	if error_flashes_left == 0:
		_start_security_system()
		return
	
	if error_flashes_left % 2 == 1:
		textbox.bbcode_text = current_bbcode
	else:
		textbox.bbcode_text = current_bbcode_with_error
	error_flash_timer.start()