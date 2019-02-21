extends VBoxContainer

export (String) var bus_name


func _ready():
	$Slider.value = global.music_volume if bus_name == 'Music' else global.effects_volume
	$Label.text = bus_name + ' volume'

func _on_Slider_value_changed(value):
	var signal_name = bus_name.to_lower() + '_volume_changed'
	global.emit_signal(signal_name, value)
