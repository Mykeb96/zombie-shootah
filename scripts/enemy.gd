extends KinematicBody2D

var player: KinematicBody2D
var globalData: Node
var velocity : Vector2 = Vector2()
var health : int = 2
var score : Node
var isHit : bool = false

func _ready():
	player = get_node("/root/Node2D/Player")
	globalData = get_node("/root/score")

func move():
	isHit = false
	#faces enemy towards player and moves in that direction
	velocity = Vector2()
	velocity += position.direction_to(player.position) * 50
	$AnimatedSprite.play("walk")
	look_at(player.position)
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#if the enemy collides with a bullet subtract one health and destroy bullet
		if collision.collider.name.find("Bullet") != -1:
			if !isHit:
				health = health - 1
				isHit = true
				collision.collider.queue_free()



func _physics_process(_delta):
	move()
	#if enemy drops to 0 hp, then it dies and adds score
	if health == 0:
		queue_free()
		globalData.score += 1
