extends Control

export (PackedScene) var InventoryItem

var code_binder_texture = preload("res://images/inventory_code_binder.png")
var code_page_texture = preload("res://images/inventory_single_page.png")
var planet_database_texture = preload("res://images/inventory_planet_database.png")
var tablet_texture = preload("res://images/inventory_tablet.png")

var inventory_bindings = []

func _ready():
	global.connect("code_binder_acquired", self, "_on_code_binder_acquired")
	global.connect("code_page_acquired", self, "_on_code_page_acquired")
	global.connect("planet_database_acquired", self, "_on_planet_database_acquired")
	global.connect("tablet_acquired", self, "_on_tablet_acquired")


func _process(delta):
	if global.camera_is_shaking:
		return
	if Input.is_action_just_pressed("access_inventory_1") and inventory_bindings.size() >= 1:
		inventory_bindings[0].call_func()
	if Input.is_action_just_pressed("access_inventory_2") and inventory_bindings.size() >= 2:
		inventory_bindings[1].call_func()
	if Input.is_action_just_pressed("access_inventory_3") and inventory_bindings.size() >= 3:
		inventory_bindings[2].call_func()
	if Input.is_action_just_pressed("access_inventory_4") and inventory_bindings.size() >= 4:
		inventory_bindings[3].call_func()

func _open_code_binder():
	$CodePages.popup()

func _open_code_page():
	$SingleCodePage.popup()

func _open_planet_database():
	$PlanetDatabase.popup()

func _open_tablet():
	$Tablet.popup()

func _on_code_binder_acquired():
	inventory_bindings.append(funcref(self, "_open_code_binder"))
	var item = InventoryItem.instance()
	item.setup(str(inventory_bindings.size()), code_binder_texture)
	$ItemsBar.add_child(item)

func _on_code_page_acquired():
	inventory_bindings.append(funcref(self, "_open_code_page"))
	var item = InventoryItem.instance()
	item.setup(str(inventory_bindings.size()), code_page_texture)
	$ItemsBar.add_child(item)

func _on_planet_database_acquired():
	inventory_bindings.append(funcref(self, "_open_planet_database"))
	var item = InventoryItem.instance()
	item.setup(str(inventory_bindings.size()), planet_database_texture)
	$ItemsBar.add_child(item)

func _on_tablet_acquired():
	inventory_bindings.append(funcref(self, "_open_tablet"))
	var item = InventoryItem.instance()
	item.setup(str(inventory_bindings.size()), tablet_texture)
	$ItemsBar.add_child(item)