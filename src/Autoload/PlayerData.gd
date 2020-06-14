extends Node

signal player_captured
signal updated
signal died

var captures = 0 setget set_captured
var score: = 0 setget set_score
var deaths: = 0 setget set_deaths


func reset():
	self.score = 0
	self.deaths = 0
#	self.captured = 0

func set_captured(value: int)-> void:
	captures = value
	emit_signal("player_captured")
	

func set_score(new_score: int) -> void:
	score = new_score
	emit_signal("updated")


func set_deaths(new_value: int) -> void:
	deaths = new_value
	emit_signal("died")
