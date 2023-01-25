extends KinematicBody2D

var velocity : Vector2 = Vector2()
var player : KinematicBody2D
var timer : Timer

func _ready():
	player = get_node("/root/Node2D/Player")
	timer = $Timer
	look_at(get_global_mouse_position() - player.position)


func _physics_process(_delta):
	#apply forward facing velocity relative to the bullet
	var facing = Vector2(1, 0).rotated(rotation)
	velocity = facing * 400
	var _moving = move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#destroy bullet if it collides with a wall
		if collision.collider.name.find("TileMap2") != -1:
			queue_free()
