extends Node

#OUTPUT SIGNALS
signal game_state_changed_output_signal
signal player_rolled_output_signal
signal enemy_rolled_output_signal

#INPUT SIGNALS
signal start_game_input_signal
signal player_roll_input_signal
signal enemy_roll_input_signal
signal start_new_round_input_signal
signal end_game_input_signal

#global variable
var game_config: GameConfig = GameConfig.new(
	PlayerSlice.Player.id, 
	PlayerSlice.Enemy.id
)

var current_game_scene_config = {
	"background": "res://assets/background/gameScene.png",
	"enemy": "res://assets/persons/player.png"
}

func set_current_game_scene_config(config):
	current_game_scene_config = config;
	return;

func _ready():
	start_game_input_signal.connect(_on_start_game_input_signal)
	player_roll_input_signal.connect(_on_player_roll_input_signal)
	enemy_roll_input_signal.connect(_on_enemy_roll_input_signal)
	start_new_round_input_signal.connect(_on_start_new_round_input_signal)
	end_game_input_signal.connect(_on_end_game_input_signal)
	
	enemy_rolled_output_signal.connect(_on_enemy_rolled_output_signal)

#Input handlers
func _on_end_game_input_signal():
	game_config.end_game();
	emit_signal("game_state_changed_output_signal")

func _on_start_game_input_signal():
	print('handle game start')
	game_config.start_game();
	emit_signal("game_state_changed_output_signal")

func _on_player_roll_input_signal():
	game_config.rollDicePlayer();
	emit_signal("game_state_changed_output_signal")
	emit_signal("player_rolled_output_signal")

func _on_enemy_roll_input_signal():
	game_config.rollDiceEnemy();
	emit_signal("enemy_rolled_output_signal")
	emit_signal("game_state_changed_output_signal")

func _on_enemy_rolled_output_signal():
	game_config.calculateResult();
	emit_signal("game_state_changed_output_signal")
	
func _on_start_new_round_input_signal():
	game_config.resetGameState();
	emit_signal("game_state_changed_output_signal")

func get_game_state_data():
	return game_config.describe();

func get_game_state_round():
	return game_config.state;

func get_game_state_bet():
	return game_config.bet;

func get_current_roll():
	return game_config.current_roll;

func get_current_round():
	return game_config.current_round_describe();

func can_start_game():
	return game_config.state == Globals.GameState["IDLE"] || game_config.state == ''

func can_player_roll():
	return game_config.state == Globals.GameState["PLAYER_1_TURN"]
