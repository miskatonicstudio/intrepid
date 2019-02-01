extends HBoxContainer

func _ready():
	global.connect("code_page_acquired", self, "_on_code_page_acquired")

func _on_code_page_acquired():
	visible = true
