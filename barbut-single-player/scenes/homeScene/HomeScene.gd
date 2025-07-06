extends Node

@onready var LeaveRoomButton = $LeaveRoomButton

func _ready():
	LeaveRoomButton.pressed.connect(_on_click_leave_room)
	
func _on_click_leave_room():
	get_tree().change_scene_to_file("res://scenes/gameMap/GameMap.tscn")
	return
