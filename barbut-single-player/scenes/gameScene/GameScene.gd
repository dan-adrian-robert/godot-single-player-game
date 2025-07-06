extends Node2D

@onready var Metadata = $Metadata

@onready var EnemyRollTimer = $EnemyRollTimer
@onready var StartNewRoundTimer = $StartNewRoundTimer

@onready var RoundResultLabel = $RoundResultLabel
@onready var ActiveRoundLabel = $ActiveRoundLabel

@onready var Dice1 = $Dice1
@onready var Dice2 = $Dice2

#sounds
@onready var DiceRollSound = $DiceRollSound
@onready var WinRoundSound = $WinRoundSound
@onready var TieRoundSound = $TieRoundSound
@onready var LoseRoundSound = $LoseRoundSound

@onready var GameScene = $GameScene
@onready var Enemy = $Enemy
@onready var LeaveRoomButton = $LeaveRoomButton

var timeToRollTimer = 3;
var newRoundTimer = 5;

func _ready():
	load_place(GameSlice.current_game_scene_config)
	LeaveRoomButton.pressed.connect(_on_leave_game_room)
	update_game_state()

	GameSlice.connect("game_state_changed_output_signal", Callable(self, "update_game_state"))
	GameSlice.connect("player_rolled_output_signal", Callable(self, "start_enemy_timer"))
	GameSlice.connect("enemy_rolled_output_signal", Callable(self, "start_new_round_timer"))

func update_game_state():

	var betText = str(GameSlice.get_game_state_bet())

	update_dices();
	update_round_info();
	update_result_info();

	if(GameSlice.game_config.state == Globals.GameState["PLAYER_2_TURN"]):
		DiceRollSound.play()

func update_result_info():
	var soundList = [WinRoundSound, LoseRoundSound, TieRoundSound]
	var soundIndex = GameSlice.game_config.getResultSoundIndex()

	RoundResultLabel.visible = GameSlice.game_config.state == Globals.GameState["END_TURN"]
	RoundResultLabel.text = GameSlice.game_config.getResultText();

func update_round_info():
	ActiveRoundLabel.visible = GameSlice.get_game_state_round() == Globals.GameState["END_TURN"]
	ActiveRoundLabel.text = GameSlice.get_current_round()

func update_dices():
	Dice1.visible = false;
	Dice2.visible = false;
	
	var state = GameSlice.get_game_state_round();
	var current_roll = GameSlice.get_current_roll();
	
	var face1 = current_roll["dice1"];
	var face2 = current_roll["dice2"];

	if((state == Globals.GameState["PLAYER_2_TURN"] || state == Globals.GameState["END_TURN"])):
		Dice1.play("default", false)
		Dice1.frame = face1 -1
		Dice1.visible = true;
		
		Dice2.play("default", false)
		Dice2.frame = face2 -1
		Dice2.visible = true;

func start_enemy_timer():
	EnemyRollTimer.start(timeToRollTimer)
	
func start_new_round_timer():
	StartNewRoundTimer.start(newRoundTimer)
	DiceRollSound.play()

func _on_enemy_roll_timer_timeout() -> void:
	print('emit enemy_roll_input_signal')
	GameSlice.emit_signal('enemy_roll_input_signal')

func _on_start_new_round_timer_timeout() -> void:
	print('START new round timer triggered')
	GameSlice.emit_signal('start_new_round_input_signal')

func _on_leave_game_room():
	get_tree().change_scene_to_file("res://scenes/gameMap/GameMap.tscn")

func _on_roll_dice():
	GameSlice.emit_signal('player_roll_input_signal')

func _on_start_game():
	GameSlice.emit_signal('start_game_input_signal')
	return;

func load_place(config: Dictionary) -> void:
	GameScene.texture = load(config["background"])
	Enemy.texture = load(config["enemy"])
	return;
