extends KinematicBody2D

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
const bulletPath = preload("res://scenes/bullet.tscn")
const enemyPath = preload("res://scenes/enemy.tscn")
const end_screenPath = preload("res://scenes/end_screen.tscn")
onready var timer = $Timer
var map : Node2D
var bulletDelay : int = 0
var isWalking : bool = false

func generate_random_vector():
	var x = rand_range(-1000, 1000)
	var y = rand_range(-750, 750)
	
	if (x > position.x + 250 || x < position.x - 250) && (y > position.y + 250 || y < position.y - 250):
		return Vector2(x, y)
	else:
		return generate_random_vector()

#creates new instance of an enemy and gives it a random position on the map
func spawn_enemy():
	var enemy = enemyPath.instance()
	enemy.set_name('Enemy')
	enemy.position = generate_random_vector()
	map.add_child(enemy)

func _ready():
	map = get_node("/root/Node2D")

#creates new instance of a bullet and fires it relative to the player's position
func shoot():
	bulletDelay += 1
	if (bulletDelay == 10):
		var bullet = bulletPath.instance()
		get_parent().add_child(bullet)
		bullet.position = $Node2D/Position2D.global_position
		$gun_shot.play()
		bulletDelay = 0

func dash():
	print("dashed")
	$dash.play()
	get_node("Node2D2/Position2D/Particles2D").emitting = true

	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * 2000)
	

#player walking instructions
func read_input():
	velocity = Vector2()
	$Node2D.look_at(get_global_mouse_position())
#	$Node2D2.look_at(get_global_mouse_position())
	if isWalking == true:
		$AnimatedSprite.play("walk")
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		isWalking = true
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		isWalking = true
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		isWalking = true
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		isWalking = true
		
	if velocity == Vector2():
		$AnimatedSprite.stop()
		
	velocity = velocity.normalized()
	$Node2D2.look_at(position + velocity)
	velocity = move_and_slide(velocity * 200)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#if the player collides with an enemy then it ends the game
		if collision.collider.name.find("Enemy") != -1:
			var _end_game = get_tree().change_scene("res://scenes/end_screen.tscn")

	#shoots if player left clicks
	if Input.is_action_pressed("ui_accept"):
		shoot()
		
	if Input.is_action_just_pressed("dash"):
		dash()
	
func _physics_process(_delta):
	look_at(get_global_mouse_position())
	read_input()
	timer.set_wait_time(0.1)


func _on_Timer_timeout():
	spawn_enemy()
