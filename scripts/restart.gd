extends Control

var globalData : Node

func _ready():
	$dead.play()

#resets the game's score and goes back to main scene
func _on_Button_pressed():
	globalData = get_node("/root/score")
	globalData.score = 0
	Global.goto_scene("res://scenes/main.tscn")
