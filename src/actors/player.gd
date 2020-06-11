extends KinematicBody2D

export var stomp_impulse: = 200.0

const FLOOR = Vector2(0,-1)
var GRAVITY = 20
const FIREBALL = preload("res://src/Objects/Fireball.tscn")
const UP_SPEED = 50

var velocity = Vector2()
var on_floor = false

var speed = Vector2(50, 100)

func _on_StompDetector_area_entered(area: Area2D) -> void:
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()
	


func _physics_process(delta):
	
	if Input.is_action_just_released("ui_up") and velocity.y < 0.0:
		velocity.y = 0;
	velocity.y += GRAVITY
		
	if Input.is_action_pressed("ui_right"):
		velocity.x = 470
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -470
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		
	else:
		velocity.x = 0
		if on_floor == true:
			$AnimatedSprite.play("idle")
			
	if Input.is_action_just_pressed("ui_focus_next") and not (Input.is_action_just_released("ui_right") or 
			Input.is_action_just_released("ui_left") or Input.is_action_pressed("ui_right") or 
			Input.is_action_pressed("ui_left") or Input.is_action_just_released("ui_up") or 
			Input.is_action_pressed("ui_up")):
		$AnimatedSprite.play("shooting")
		var fireball = FIREBALL.instance()
		var shoot = $ShootSound
		shoot.play()
		if sign($Position2D.position.x) == 1:
			fireball.set_bullet_direction(1)
		else:
			fireball.set_bullet_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			if on_floor == true:
				velocity.y = -800
				on_floor = false
				var sound = $JumpSound
				sound.play()
				
	if is_on_floor():
		on_floor = true
	else:
		on_floor = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity, FLOOR)
	
func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump = 0.0
	if Input.is_action_pressed("ui_up"):
		stomp_jump = -speed.y 
	else: 
		stomp_jump = -stomp_impulse
		
	return Vector2(linear_velocity.x, stomp_jump)

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
