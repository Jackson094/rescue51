extends Node


onready var scene_tree: SceneTree = get_tree()
onready var score_label: Label = $Score
onready var pause_overlay: ColorRect = $PauseOverlay
onready var title_label: Label = $PauseOverlay/Title
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton
onready var background_image: TextureRect = $CanvasLayer/Bimage


const MESSAGE_DIED: = "You died"
const MESSAGE_CAPTURED = "You've been captured"

var paused: = false setget set_paused


func _ready() -> void:
	PlayerData.connect("updated", self, "update_interface")
	PlayerData.connect("died", self, "_on_Player_died")
	PlayerData.connect("player_captured", self, "_on_Player_captured")

func _on_Player_captured() -> void:
	self.paused = true
	title_label.text = MESSAGE_CAPTURED
	#background_image.visible = not background_image.visible 
	
	#background_image.load(root/assets/background/autopsy.jpg)

func _on_Player_died() -> void:
	self.paused = true

	title_label.text = MESSAGE_DIED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and title_label.text != MESSAGE_CAPTURED:
		self.paused = not self.paused





func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
