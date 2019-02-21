extends Control

const PLANET_SCHEDULES = [
	['Ashorix', '1102051'],
	['Pleaziria', '1410363'],
	['Meacir', '0801146'],
	['Frarth', '0219222'],
	['Scion', '1213204'],
	['Quehiri', '2514274'],
	['Strion', '1608018'],
	['Aenus', '0614180'],
	['Nainerth', '1227019'],
	['Sponoe', '1731223'],
	['Crinda', '3911085'],
	['Estichi', '0415337'],
	['Potrion', '0318078'],
	['Scippe', '3711056'],
	['Tronoe', '1305191'],
	['Plohaliv', '0733126'],
	['Riunus', '1509392'],
	['Utania', '3708031'],
	['Droquos', '2211083'],
	['Chapohines', '3405075'],
	['Rastumia', '1233080'],
	['Asleon', '1130109'],
	['Skao', '0419053'],
	['Vayrilia', '1428039'],
	['Gapreshan', '0507126'],
	['Mosmoenia', '2220164'],
	['Crippe', '0409127'],
	['Astrarth', '1903307'],
	['Dremetis', '2207050'],
	['Aestea', '2911021'],
	['Pryke', '1801036'],
	['Sceutis', '3506179'],
	['Euruta', '1408224'],
	['Snevarus', '1301053'],
	['Naphus', '1827318'],
	['Aspichi', '2305137'],
	['Xecriamia', '0112237'],
	['Robloaria', '2219093'],
	['Lestretis', '0803335'],
	['Oscadus', '2634035'],
	['Badrion', '0507127'],
	['Griri', '0829154'],
	['Xiaphus', '1115221'],
	['Theneos', '0819048'],
	['Aprouhiri', '2829335'],
	['Botadus', '2137059'],
	['Opryke', '1301099'],
	['Soyrus', '2413190'],
	['Yecury', '0425303'],
	['Yiaruta', '0913064'],
	['Gehorth', '2713351'],
	['Stosamia', '1704072'],
	['Kiovis', '1502358'],
	['Skagua', '0703349'],
	['Meuris', '1509144'],
	['Cusceus', '3312297'],
	['Cillion', '1317052'],
	['Tuglilia', '0819015'],
	['Aenope', '2531079'],
	['Daclides', '0929043'],
	['Gubos', '1703372'],
	['Zuspara', '1508016'],
	['Resteyn', '2708209'],
	['Ustruna', '3511032'],
	['Sceron', '0408164'],
	['Pruolia', '0503334'],
	['Mosmyria', '2007127'],
	['Greron', '0611369'],
	['Iaeter', '0435033'],
	['Teaturn', '0415238'],
	['Geonides', '0829125'], # the one
	['Cruna', '2308181'],
	['Scorix', '1127035'],
	['Spart', '0517098'],
	['Kearus', '0619227'],
	['Oglade', '2316173'],
	['Glides', '3511042'],
	['Draqua', '3009048'],
	['Beolea', '1317330'],
	['Fenope', '0518124'],
]
const BRIGHT_COLOR = Color('#87e1fd')
const DARK_COLOR = Color('#2268c1')

onready var panel = $HBoxContainer/Panel
onready var scroll = panel.get_node('VScrollBar')
onready var vbox_container = panel.get_node('VBoxContainer')
onready var font = load('res://fonts/planet_scheduler_font.tres')

func _ready():
	panel.rect_size = Vector2(400, 400)
	
	var label_style = StyleBoxFlat.new()
	label_style.set_bg_color(DARK_COLOR)
	label_style.set_border_color(DARK_COLOR)
	label_style.set_border_width_all(5)
	
	vbox_container.add_spacer(false)
	
	for i in range(len(PLANET_SCHEDULES)):
		var planet_name = PLANET_SCHEDULES[i][0]
		var planet_schedule = PLANET_SCHEDULES[i][1]
		
		var hbox = HBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = planet_name
		name_label.set("custom_styles/normal", label_style)
		name_label.set("custom_fonts/font", font)
		name_label.set("custom_colors/font_color", BRIGHT_COLOR)
		name_label.rect_min_size.x = 230
		hbox.add_child(name_label)
		
		var number_label = Label.new()
		number_label.text = planet_schedule
		number_label.align = Label.ALIGN_CENTER
		number_label.rect_min_size.x = 142
		number_label.set("custom_styles/normal", label_style)
		number_label.set("custom_fonts/font", font)
		number_label.set("custom_colors/font_color", BRIGHT_COLOR)
		hbox.add_child(number_label)
		
		vbox_container.add_child(hbox)
	
	vbox_container.add_spacer(false)
	vbox_container.rect_position.x = scroll.rect_size.x + 8
	
	scroll.max_value = vbox_container.rect_size.y - panel.rect_size.y
	self.scroll(600)


func scroll(value):
	var actual_value = clamp(scroll.value + value, scroll.min_value, scroll.max_value)
	scroll.value = actual_value
	vbox_container.rect_position.y = -int(actual_value)
