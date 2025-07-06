extends Node

@onready var LeaveButton = $LeaveButton

func _ready():
	LeaveButton.pressed.connect(_on_click_leave_room)
	
func _on_click_leave_room():
	get_tree().change_scene_to_file("res://scenes/gameMap/GameMap.tscn")
	return
