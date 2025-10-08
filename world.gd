extends Node2D

const GameOverScreen = preload("res://scenes/ui/game_over_screen.tscn")

@onready var player := $ActorConteiner/Player
@onready var camera := $Camera
@onready var game_timer := $GameTimer
@onready var game_ui := $GameUI

func _ready() -> void:
	GameManager.reset()
	game_timer.start()

func _process(_delta: float) -> void:
	game_ui.update_timer(ceil(game_timer.time_left))
	if is_instance_valid(player):
		if player.position.x > camera.position.x:
			camera.position.x = player.position.x 

func game_over() -> void:
	get_tree().paused = true
	
	var game_over_instance = GameOverScreen.instantiate()
	
	add_child(game_over_instance)
	
	var final_score = GameManager.get_score()
	game_over_instance.set_final_score(final_score)

func _on_game_timer_timeout() -> void:
	game_over()
