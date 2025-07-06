extends Node

@onready var BlockSpriteButton = $BlockLocation/BlockSpriteButton
@onready var HomeSpriteButton = $HomeLocation/HomeSpriteButton
@onready var ShopSpriteButton = $ShopLocation/ShopSpriteButton
@onready var ParcSpriteButton = $ParcLocation/ParcSpriteButton

func _ready():
	BlockSpriteButton.pressed.connect(_on_click_block)
	HomeSpriteButton.pressed.connect(_on_click_home)
	ShopSpriteButton.pressed.connect(_on_click_shop)
	ParcSpriteButton.pressed.connect(_on_click_parc)
	
func _on_click_block():
	GameSlice.set_current_game_scene_config(Globals.BlocGameSceneConfig)
	get_tree().change_scene_to_file("res://scenes/gameScene/GameScene.tscn")
	return

func _on_click_home():
	get_tree().change_scene_to_file("res://scenes/homeScene/HomeScene.tscn")
	return

func _on_click_shop():
	get_tree().change_scene_to_file("res://scenes/shopScene/ShopScene.tscn")
	return

func _on_click_parc():
	GameSlice.set_current_game_scene_config(Globals.ParcGameSceneConfig)
	get_tree().change_scene_to_file("res://scenes/gameScene/GameScene.tscn")
