extends Area2D



func _on_LadderBody_body_entered(body):
	if body.name == "Player":
		get_node("../Player").on_ladder = true


func _on_LadderBody_body_exited(body):
	if body.name == "Player":
		get_node("../Player").on_ladder = true
