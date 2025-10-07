extends Node2D


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_opções_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings.gd")


func _on_sair_pressed() -> void:
	get_tree().quit()
