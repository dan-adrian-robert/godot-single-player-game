extends Node

@onready var EnemyGoldLabel = $EnemyGoldLabel
@onready var EnemyNameLabel = $EnemyNameLabel
@onready var GameStateLabel = $GameStateLabel

func _ready():
	GameSlice.connect("game_state_changed_output_signal", Callable(self, "update_enemy_info"))
	update_enemy_info()
	return;

func update_enemy_info():
	EnemyGoldLabel.text = """Enemy Money: %s""" % [PlayerSlice.get_enemy_money()];
	GameStateLabel.text = str(GameSlice.get_game_state_round())
	EnemyNameLabel.text = PlayerSlice.get_enemy_name();
	return;
