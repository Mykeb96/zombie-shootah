extends Button

onready var popUp = get_node("/root/Control/WindowDialog")

func _pressed():
	popUp.popup()
