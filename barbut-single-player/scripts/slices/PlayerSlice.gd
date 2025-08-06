extends Node

var Enemy := {
	"id": 'boot',
	"money": 100,
	"name": "Eugene"
}

var Player := {
	"id": "playerID",
	"money": 200,
}

var EntityMap := {
	Enemy["id"]: Enemy,
	Player["id"]: Player
}

signal change_ballance_input_signal

signal enemy_state_changed_outout_signal

func _ready():
	change_ballance_input_signal.connect(_on_change_ballance_input_signal)

	print('enemy state change')
	return;

func _on_change_ballance_input_signal(payload):
	EntityMap[payload.id].money += payload.amount;
	emit_signal("enemy_state_changed_outout_signal")

func get_enemy_money():
	return str(Enemy["money"])

func get_enemy_name():	
	return str(Enemy["name"])

func get_player_money():
	return str(Player["money"])
