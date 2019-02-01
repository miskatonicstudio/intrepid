extends Spatial

onready var alert_sound = get_node('EmergencySystemModel/Alert')

func _ready():
	global.connect('emergency_screen_closed', self, '_on_Popup_emergency_screen_closed')
	$Screen.set_screen($Popup.get_screen())


func _on_Screen_activated():
	$Popup.popup()


func _on_Popup_emergency_screen_closed():
	alert_sound.stop()
