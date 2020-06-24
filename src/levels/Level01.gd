extends Node2D




func _ready():
	var boss_health =$RobotEnemy/Health
	var boss_health_bar = $RobotEnemy/HealthBar
	
	#boss_health.connect("changed",boss_health_bar,"set_value")
	#boss_health.connect("max_changed",boss_health_bar,"set_max")
	#boss_health.initialize()
	
	var player_health = $Player/Health
	var healthbar = $Player/HealthBar
	
	player_health.connect("changed",healthbar,"set_value")
	player_health.connect("max_changed",healthbar,"set_max")
	player_health.initialize()
	
	get_node("Node2D/AnimationPlayer").play("horizontal")
