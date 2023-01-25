extends Label

var globalData : Node

func _ready():
	globalData = get_node("/root/score")

func _process(_delta):
	#updates the text inside of label to match the score
	set_text(str("Score: ", globalData.score))
