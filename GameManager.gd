extends Node

const PAUSE_SCREEN = preload("res://scenes/ui/pause_screen.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			var nodes_in_group = get_tree().get_nodes_in_group("pause_screen")
			if not nodes_in_group.is_empty():
				nodes_in_group[0].queue_free()
		else:
			get_tree().paused = true
			var pause_instance = PAUSE_SCREEN.instantiate()
			pause_instance.add_to_group("pause_screen")
			get_tree().root.add_child(pause_instance)

signal score_updated(new_score)

var current_score: int = 0

func add_score(amount: int) -> void:
	current_score += amount
	score_updated.emit(current_score)

func get_score() -> int:
	return current_score

func reset() -> void:
	current_score = 0
