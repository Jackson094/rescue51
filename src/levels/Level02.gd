extends Node2D



func _ready():
	var player_health = $Player/Health
#	var healthbar = $InterfaceLayer/UserInterface/HealthBar
	var healthbar = $Player/HealthBar
	
	player_health.connect("changed",healthbar,"set_value")
	player_health.connect("max_changed",healthbar,"set_max")
	player_health.initialize()
