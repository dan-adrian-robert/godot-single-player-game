extends Node

var GameState := { 
	"IDLE": "IDLE",
	"PLAYER_1_TURN":"PLAYER_1_TURN",
	"PLAYER_2_TURN":"PLAYER_2_TURN",
	"END_TURN": "END_TURN",
}

var GameMode := { 
	"DEFAULT": "DEFAULT",
	"BIG_DICE":"BIG_DICE",
	"SMALL_DICE":"SMALL_DICE",
}

var BlocGameSceneConfig := {
	"background": "res://assets/background/gameScene.png",
	"enemy": "res://assets/persons/player.png"
}

var ParcGameSceneConfig := {
	"background": "res://assets/background/parcBackground.png",
	"enemy": "res://assets/persons/sport_enemy.png"
}
