extends Node

func _ready():
	get_node("main-menu/VB/Start").pressed.connect(on_new_game_pressed)
	get_node("main-menu/Exit").pressed.connect(on_quit_pressed)

func on_new_game_pressed():
	get_tree().change_scene_to_file("res://main-scene/GameScene.tscn")

func on_quit_pressed():
	get_tree().quit()
