extends Node2D

@export var enemy_scene: PackedScene
#@export var spawn_points_parent: Node2D

var active_spawn_points = []

func spawn_enemy():
	if active_spawn_points.is_empty():
		#print("Nenhum ponto de spawn ativo na tela.")
		return

	# Escolhe um ponto aleatório APENAS da lista de pontos ativos.
	var random_point = active_spawn_points.pick_random()
	var new_enemy = enemy_scene.instantiate()
	
	new_enemy.global_position = random_point.global_position
	
	get_parent().add_child(new_enemy)
	print("Inimigo spawnado em: ", random_point.name)


func screen_entered(spawn_point) -> void:
		if not spawn_point in active_spawn_points:
			active_spawn_points.append(spawn_point)
			print(spawn_point.name, " entrou na tela. Pontos ativos: ", active_spawn_points.size())


func screen_exited(spawn_point) -> void:
	if spawn_point in active_spawn_points:
			active_spawn_points.erase(spawn_point)
			print(spawn_point.name, " saiu da tela. Pontos ativos: ", active_spawn_points.size())

func _on_timer_timeout() -> void:
	print("Timer tentou spawnar...") # <-- ADICIONE ESTA LINHA
	spawn_enemy()
