extends KinematicBody2D

export(int) var hp =3

const GRAVITY = 9.81
const SPEED = 100
const FLOOR = Vector2(0,-1)

var velocity = Vector2()

var react_time = 400
var next_direction = 0
var next_direction_time = 0
var target_player_dist = 150
var target_player_shoot = 90
var dir = 0
var next_jump_time = -1

var eye_reach = 200
var vision = 768

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
	hp -= 1
	$Health.set_current(hp)
	if hp <= 0:
		is_dead = true
		velocity = Vector2(0,0)
#		$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		$Timer.start()

func _process(delta):
	if Player.position.x < position.x - target_player_dist and sees_player():
		next_direction = -1
		next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 400
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("running")
#	elif Player.position.x < position.x - target_player_shoot and sees_player():
#		next_direction = -1
#		next_direction_time = OS.get_ticks_msec() + react_time
#		velocity.x = next_direction * 320
#		$AnimatedSprite.flip_h = true
#		$AnimatedSprite.play("jumping")
	elif Player.position.x > position.x + target_player_dist and sees_player():
		next_direction = 1
		next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 400
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("running")
#	elif Player.position.x > position.x + target_player_shoot and sees_player():
#		next_direction = 1
#		next_direction_time = OS.get_ticks_msec() + react_time
#		velocity.x = next_direction * 320
#		$AnimatedSprite.flip_h = false
#		$AnimatedSprite.play("jumping")
	elif not sees_player():
		next_direction = 0
		next_direction_time = OS.get_ticks_msec() + react_time
		velocity.x = next_direction * 400
		$AnimatedSprite.play("idle")
	

	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - 64 and sees_player():
			velocity.y = -600
			$AnimatedSprite.play("jumping")
		next_jump_time = -1

	if Player.position.y < position.y - 64 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time

	if is_on_floor() and velocity.y > 0:
		velocity.y = 0
	
	if not is_on_floor() and velocity.y > 0:
		velocity.y = 550
	
	if is_dead == false:
		#$AnimatedSprite.play("idle")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		dir = dir * -1





func _on_Timer_timeout():
	queue_free()
