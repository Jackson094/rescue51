extends Node2D




func _ready():
	
	var boss3_health =$RobotEnemy3/Health
	var boss3_health_bar = $RobotEnemy3/HealthBar
	
	boss3_health.connect("changed",boss3_health_bar,"set_value")
	boss3_health.connect("max_changed",boss3_health_bar,"set_max")
	boss3_health.initialize()
	
	
	var boss2_health =$RobotEnemy2/Health
	var boss2_health_bar = $RobotEnemy2/HealthBar
	
	boss2_health.connect("changed",boss2_health_bar,"set_value")
	boss2_health.connect("max_changed",boss2_health_bar,"set_max")
	boss2_health.initialize()
	
	
	var boss_health =$RobotEnemy/Health
	var boss_health_bar = $RobotEnemy/HealthBar
	
	boss_health.connect("changed",boss_health_bar,"set_value")
	boss_health.connect("max_changed",boss_health_bar,"set_max")
	boss_health.initialize()
	
	var player_health = $Player/Health
#	var healthbar = $InterfaceLayer/UserInterface/HealthBar
	var healthbar = $Player/HealthBar
	
	player_health.connect("changed",healthbar,"set_value")
	player_health.connect("max_changed",healthbar,"set_max")
	player_health.initialize()
