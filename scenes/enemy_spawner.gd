class_name EnemySpawner
extends Node

@export var enemy_scenes: Array[PackedScene]
@export var spawn_points_container: Node2D
@export var target_container: Node2D

var _spawn_points: Array

func _ready() -> void:
	if spawn_points_container:
		_spawn_points = spawn_points_container.get_children()
	else:
		print("AVISO: Container de spawn points não foi definido no Spawner.")
		
func spawn_enemy() -> void:
	if enemy_scenes.is_empty() or _spawn_points.is_empty():
		return

	var random_enemy_scene: PackedScene = enemy_scenes.pick_random()

	var random_spawn_point: Marker2D = _spawn_points.pick_random()
	
	var enemy = random_enemy_scene.instantiate()
	
	if target_container:
		target_container.add_child(enemy)
		enemy.global_position = random_spawn_point.global_position
		
		if enemy.has_method("set_player"):
			enemy.set_player(get_tree().get_first_node_in_group("player"))
		elif "player" in enemy:
			var player_node = get_tree().get_first_node_in_group("player")
			if player_node:
				enemy.player = player_node
	else:
		print("AVISO: Target container não foi definido no Spawner.")


func _on_timer_timeout() -> void:
	spawn_enemy()
