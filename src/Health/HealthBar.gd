extends ProgressBar

onready var scene_tree: SceneTree = get_tree()
#value = (scene_tree.root.get_node().get_node("Player").hp)

#var value = 1
#var value1 = get_tree().root.get_node("Level01").get_node("Player").hp
#var level1 = get_tree().root.get_node("Level01").get_node("Player").hp
#var level2 = get_tree().root.get_node("Level02").get_node("Player").hp
#var level3 = get_tree().root.get_node("Level03").get_node("Player").hp
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(delta):
	pass
#	value = get_tree().root.get_node("Level01").get_node("Player").hp
#	if (get_tree().root.get_node("Level01").get_node("Player").hp) != 0 :
#	if value1 > 1:
#	if level1 !=0:
#	value = scene_tree.root.get_node("Player").hp
#	if	(get_tree().root.get_node("Level01").get_node("Player").hp) != 0: 
#		value = get_tree().root.get_node("Level01").get_node("Player").hp
#	elif (get_tree().root.get_node("Level02").get_node("Player").hp) != null: 
#		value = get_tree().root.get_node("Level02").get_node("Player").hp
		
		
#		value1 = get_tree().root.get_node("Level01").get_node("Player").hp
#	if  value == 1:
#		value = get_node("Player").hp
#	if value <= 0:
#		velocity = Vector2(0,0)
#		PlayerData.deaths += 1
	

