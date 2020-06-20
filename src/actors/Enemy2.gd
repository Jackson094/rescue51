extends KinematicBody2D

const GRAVITY = 9.8
const SPEED = 100
const FLOOR = Vector2(0,-1)

#const FIREBALL = preload("res://src/Objects/Fireball.tscn")
const FIREBALL = preload("res://src/Objects/Fireball2.tscn")

var velocity = Vector2()

var react_time = 500
var next_direction = 0
var next_direction_time = 0
var target_player_dist = 300
var target_player_shoot = 200
var dir = 0
var next_jump_time = -1

var eye_reach = 200
var vision = 576

var is_dead = false

onready var Player = get_parent().get_node("Player")

func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_left = eye_center + Vector2(-eye_reach, 0)
	var eye_right = eye_center + Vector2(eye_reach, 0)
	
	var player_position = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1,1)
	var top_left = player_position + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_position + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_position + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_position + Vector2(player_extents.x, player_extents.y)
	
	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1)
			if collision and collision.collider.name == "Player":
				return true
	return false
			
func dead():
	is_dead = true
	velocity = Vector2(0,0)
#	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$Timer.start()

func _process(delta):
	if Player.position.x < position.x - target_player_dist and sees_player():
		$Timer2.stop()
		next_direction = -1
		#next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 360
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("running")
		$Timer3.start()
	elif Player.position.x < position.x - target_player_shoot and sees_player():
		next_direction = -1
		next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 360
#		$AnimatedSprite.flip_h = true
#		$AnimatedSprite.play("shooting")
#		var fireball = FIREBALL.instance()
#		if sign($Position2D2.position.x) == 1:
#			fireball.set_bullet_direction(1)
##			$Position2D.position.x *= -1
#		else:
#			fireball.set_bullet_direction(-1)
#		fireball.set_bullet_direction(-1)
#		get_parent().add_child(fireball)
#		fireball.position = $Position2D2.global_position
		$Timer2.start()
	elif Player.position.x > position.x + target_player_dist and sees_player():
		$Timer3.stop()
		next_direction = 1
		#next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 360
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("running")
		$Timer2.start()
	elif Player.position.x > position.x + target_player_shoot and sees_player():
		next_direction = 1
		#next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 360
#		$AnimatedSprite.flip_h = false
#		$AnimatedSprite.play("shooting")
#		var fireball = FIREBALL.instance()
#		if sign($Position2D.position.x) == -1:
#			fireball.set_bullet_direction(-1)
##			$Position2D.position.x *= -1
#		else:
#			fireball.set_bullet_direction(1)
#		fireball.set_bullet_direction(1)
#		get_parent().add_child(fireball)
#		fireball.position = $Position2D.global_position
		$Timer3.start()
	elif not sees_player():
		next_direction = 0
		next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 310
		$AnimatedSprite.play("idle")
		if not $Timer2.is_stopped():
			$Timer2.stop()
		if not $Timer3.is_stopped():
			$Timer3.stop()
#	elif Player.position.x == position.x and sees_player():
#		next_direction = 0
#		next_direction_time = OS.get_ticks_msec() + react_time
#		velocity.x = next_direction * 310
#		$AnimatedSprite.play("shooting")
		
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - 20 and sees_player():
			velocity.y = -560
		next_jump_time = -1

	if Player.position.y < position.y - 20 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time

	if is_on_floor() and velocity.y > 0:
		velocity.y = 0
	
	if not is_on_floor() and velocity.y > 0:
		velocity.y = 570
	
	if is_dead == false:
		#$AnimatedSprite.play("idle")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		dir = dir * -1

func _on_Timer_timeout():
	queue_free()


func _on_Timer2_timeout():
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.play("shooting")
	var fireball = FIREBALL.instance()
	fireball.set_bullet_direction(1)
	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position

func _on_Timer3_timeout():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("shooting")
	var fireball = FIREBALL.instance()
	fireball.set_bullet_direction(-1)
	get_parent().add_child(fireball)
	fireball.position = $Position2D2.global_position

