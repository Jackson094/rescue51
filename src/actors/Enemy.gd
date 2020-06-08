extends KinematicBody2D

onready var stomp_area: Area2D = $StompArea2D

export var score: = 100

const FLOOR = Vector2(0,-1)
const GRAVITY = 20

var velocity = Vector2()
var speed = Vector2(150, 300)

func _ready() -> void:
	set_physics_process(false)
	velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	 
	if is_on_wall():
		velocity.x *= -1
	else:
		velocity.x *= 1
		
	velocity.y += GRAVITY
	
	velocity.y = move_and_slide(velocity, FLOOR).y


func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
	die()


func die() -> void:
	PlayerData.score += score
	queue_free()

