extends Spatial




func _on_Tablet_activated():
	global.emit_signal('tablet_acquired')
