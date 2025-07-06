extends Node
class_name GameConfig

var rounds: Array = []
var state: String = ""
var bet = 10
var table_slots = {
	"PLAYER_1": "",
	"PLAYER_2": "",
}
var active_player_id = ''
var current_roll = {
	"dice1": -1,
	"dice2": -1
}
var current_rount = {
	"PLAYER_1": {
		"dice1": '',
		"dice2": ''
	},
	"PLAYER_2": {
		"dice1": '',
		"dice2": ''
	}
}
var game_mode = null;
var winner = ""

func _init(playerId, enemyId) -> void:
	table_slots = {
		"PLAYER_1": playerId,
		"PLAYER_2": enemyId,
	}
	call_deferred("_set_initial_state")  # Delay access
	return

func _set_initial_state() -> void:
	state = Globals.GameState["IDLE"]
	game_mode = Globals.GameMode["DEFAULT"];

func current_round_describe() -> String:
	var round_description = ""
	for player_id in current_rount.keys():
		var dice1 = str(current_rount[player_id]["dice1"])
		var dice2 = str(current_rount[player_id]["dice2"])
		round_description += "\n\t%s - %s - %s" % [player_id, dice1, dice2]

	return round_description

func describe() -> String:
	var round_description = ""
	for player_id in current_rount.keys():
		var dice1 = str(current_rount[player_id]["dice1"])
		var dice2 = str(current_rount[player_id]["dice2"])
		round_description += "\n\t%s - %s - %s" % [player_id, dice1, dice2]

	var past_rounds_description = ""
	for i in range(rounds.size()):
		var round = rounds[i]
		var p1 = round["PLAYER_1"]
		var p2 = round["PLAYER_2"]
		var winner_name = round["WINNER"] if round["WINNER"] != null else "Draw"
		past_rounds_description += "\n\tR %d: P1 [%s, %s] | P2 [%s, %s] => W: %s" % [
			i + 1,
			str(p1["dice1"]),
			str(p1["dice2"]),
			str(p2["dice1"]),
			str(p2["dice2"]),
			winner_name
		]

	return """
		Game State: %s
		Player 1: %s
		Player 2: %s
		Active Player: %s
		Bet: %d
		Rounds Played: %d
		Last Roll: Dice 1 = %s, Dice 2 = %s
		Current Round:%s
		Round History:%s
		Latest Winner: %s
		""" % [
			state,
			table_slots["PLAYER_1"],
			table_slots["PLAYER_2"],
			active_player_id,
			bet,
			rounds.size(),
			str(current_roll["dice1"]),
			str(current_roll["dice2"]),
			round_description,
			past_rounds_description,
			winner if winner != null else "Draw"
		]

func start_game() -> void:
	state = Globals.GameState['PLAYER_1_TURN']
	active_player_id = table_slots['PLAYER_1']

func rollDicePlayer() -> void:
	var dice1 = randi() % 6 + 1
	var dice2 = randi() % 6 + 1
	current_roll.dice1 = dice1;
	current_roll.dice2 = dice2;
	state = Globals.GameState["PLAYER_2_TURN"]
	current_rount["PLAYER_1"] = {
		"dice1" : dice1,
		"dice2" : dice2
	};
	active_player_id = table_slots["PLAYER_2"]

func rollDiceEnemy() -> void:
	var dice1 = randi() % 6 + 1
	var dice2 = randi() % 6 + 1
	current_roll.dice1 = dice1;
	current_roll.dice2 = dice2;
	state = Globals.GameState["END_TURN"]
	current_rount["PLAYER_2"] = {
		"dice1" : dice1,
		"dice2" : dice2
	};
	active_player_id = ""

func calculateResult() -> void:
	if(game_mode == Globals.GameMode["DEFAULT"]):
		var player1Score = current_rount["PLAYER_1"].dice1 + current_rount["PLAYER_1"].dice2
		var player2Score = current_rount["PLAYER_2"].dice1 + current_rount["PLAYER_2"].dice2
		
		if(player1Score > player2Score):
			winner = "PLAYER_1"
			print("emit signal win p1")
			PlayerSlice.emit_signal('change_ballance_input_signal', {"PLAYER_1": 10, "PLAYER_2": -10})
		else: if(player2Score > player1Score):
			winner = "PLAYER_2"
			print("emit signal win p2")
			PlayerSlice.emit_signal('change_ballance_input_signal', {"PLAYER_1": -10, "PLAYER_2": 10})
		else:
			print("emit signal tie")
			winner = null
			
		var round = {
			"PLAYER_1": current_rount["PLAYER_1"],
			"PLAYER_2": current_rount["PLAYER_2"],
			"WINNER": winner
		}
		
		rounds.push_back(round);

func resetGameState() -> void:
	current_roll = {
		"dice1": -1,
		"dice2": -1
	}
	
	current_rount = {
		"PLAYER_1": {
			"dice1": -1,
			"dice2": -1,
		},
		"PLAYER_2": {
			"dice1": -1,
			"dice2": -1,
		}
	}
	
	state = Globals.GameState["PLAYER_1_TURN"]
	active_player_id = table_slots["PLAYER_1"]

func getResultSoundIndex():
	if winner == 'PLAYER_1':
		return 0;
	elif winner == 'PLAYER_2':
		return 1;
	
	return 2;

func getResultText() -> String:
	if winner == 'PLAYER_1':
		return "You won!"
	elif winner == 'PLAYER_2':
		return "Enemy won!"
	
	return "Tie"
