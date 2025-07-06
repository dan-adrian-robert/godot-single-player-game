extends Node

@onready var BetLabel = $BetLabel
@onready var PlayerMoneyLabel = $PlayerMoneyLabel

@onready var StartGameButton = $StartGameButton
@onready var RollDiceButton = $RollDiceButton


func _ready():
	RollDiceButton.pressed.connect(_on_roll_dice)
	StartGameButton.pressed.connect(_on_start_game)
	update_game_state()

	GameSlice.connect("game_state_changed_output_signal", Callable(self, "update_game_state"))
	
func _on_roll_dice():
	GameSlice.emit_signal('player_roll_input_signal')
	return;
	
func _on_start_game():
	GameSlice.emit_signal('start_game_input_signal')
	return;

func update_game_state():
	PlayerMoneyLabel.text = """Money: %s""" % [PlayerSlice.get_player_money()];

	var betText = str(GameSlice.get_game_state_bet())
	BetLabel.text = """Bet: %s""" % [betText]

	#update buttons state
	StartGameButton.disabled = !GameSlice.can_start_game();
	RollDiceButton.disabled = !GameSlice.can_player_roll();
