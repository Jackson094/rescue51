extends KinematicBody2D

export(int) var hp =3

export var stomp_impulse: = 200.0

const FLOOR = Vector2(0,-1)
export(int) var GRAVITY = 17
const FIREBALL = preload("res://src/Objects/Fireball.tscn")
const UP_SPEED = 50
var contact = false
var touch = false
var velocity = Vector2()
var on_floor = false
var timercalled = false
var speed = Vector2(50, 100)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	pass
	contact = true
	if "Friend" in body.name:
		contact = false
#	$AnimatedSprite.play("dead")
	#die()

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
			velocity.y = 700
			$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity, FLOOR)


	if !timercalled:
		if !touch:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.name == 'Danger':
					print("I collided with object", collision.collider.name)
					touch = true
					print(touch)
		else:
			hp = 0 
			$Health.set_current(hp)
			print("start timer")
			#$AnimatedSprite.play("dead")
			$Timer.start()
			timercalled = true
			
		if contact:
			hp = 0 
			$Health.set_current(hp)
			$Timer.start()
			timercalled = true
	else:
		$AnimatedSprite.play("dead")
	
func die() -> void:
	touch = true



func dead():
	hp -= 1
	$Health.set_current(hp)
	if hp <= 0:
#		$AnimatedSprite.play("dead")
#		$Timer.start()
#		velocity = Vector2(0,0)
#		PlayerData.deaths += 1
		touch = true

#func dead():
#	hp -= 1
#	$Health.set_current(hp)
#	if hp <= 0:
#		velocity = Vector2(0,0)
#		PlayerData.deaths += 1


func _on_Timer_timeout():
	print("in timer")
	if contact == true:
		PlayerData.captures += 1
	else:
		PlayerData.deaths += 1
	queue_free()
