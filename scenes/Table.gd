extends Spatial

onready var animation_player = $AnimationPlayer
onready var drawer_lock_popup = $DrawerLock


func _ready():
	global.connect('drawer_unlocked', self, '_on_DrawerLock_unlocked')


func _on_DrawerLock_unlocked():
	$DrawerLockInteractive.queue_free()
	animation_player.play('open_lock_drawer')
	$TableModel/DrawerWithLock/LockDrawerSound.play()


func _on_DrawerLockInteractive_activated():
	drawer_lock_popup.popup()


func _on_DrawerInteractive_activated():
	$DrawerInteractive.queue_free()
	animation_player.play('open_drawer')
	$TableModel/Drawer/DrawerSound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'open_drawer':
		$TableModel/Drawer/InventoryPlanetDatabase.enable_raycast()
	if anim_name == 'open_lock_drawer':
		$TableModel/DrawerWithLock/InventoryBinder.enable_raycast()


func _on_InventoryPlanetDatabase_activated():
	global.emit_signal('planet_database_acquired')


func _on_InventoryBinder_activated():
	global.emit_signal('code_binder_acquired')
