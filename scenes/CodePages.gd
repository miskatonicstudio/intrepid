extends "GamePopup.gd"

onready var screen = $Center/TextureRect

var page1 = preload('res://images/Binder_Page1.png')
var page2 = preload('res://images/Binder_Page2.png')
var page3 = preload('res://images/Binder_Page3.png')
var page4 = preload('res://images/Binder_Page4.png')
var page5 = preload('res://images/Binder_Page5.png')
var page6 = preload('res://images/Binder_Page6.png')

var CODE_PAGE_TEXTURES = []
var current_page_index = 0

func _ready():
	._ready()
	
	CODE_PAGE_TEXTURES.append(page1)
	CODE_PAGE_TEXTURES.append(page2)
	CODE_PAGE_TEXTURES.append(page3)
	CODE_PAGE_TEXTURES.append(page4)
	CODE_PAGE_TEXTURES.append(page5)
	CODE_PAGE_TEXTURES.append(page6)


func _on_TextureRect_gui_input(ev):
	if Input.is_action_just_pressed("click"):
		if screen.get_local_mouse_position().x > screen.rect_size.x / 2:
			_turn_page("right")
		else:
			_turn_page("left")


func _turn_page(direction):
	var initial_page_index = current_page_index
	if direction == "right":
		current_page_index += 1
	else:
		current_page_index -= 1
	current_page_index = clamp(current_page_index, 0, len(CODE_PAGE_TEXTURES)-1)
	screen.texture = CODE_PAGE_TEXTURES[current_page_index]

	if initial_page_index != current_page_index:
		$PageFlipSound.play()