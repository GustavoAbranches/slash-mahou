extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies: int = 5
@onready var spawn_zone: CollisionShape2D = $CollisionShape2D

func _on_timer_timeout() -> void:
	var alive = get_tree().get_nodes_in_group("enemies").size()
	if alive >= max_enemies:
		return
	
	var rect = spawn_zone.shape.get_rect()
	var pos = Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = to_global(pos)
	enemy.add_to_group("enemies")
	get_parent().add_child(enemy)
