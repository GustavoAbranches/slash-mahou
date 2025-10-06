# game_over_screen.gd

extends CanvasLayer

# Defina aqui o caminho para sua cena principal do jogo (World.tscn)
const GAME_SCENE_PATH = "res://scenes/world.tscn"
# Defina o caminho para sua cena do Menu Principal (main_menu.tscn)
const MENU_SCENE_PATH = "res://main_menu.tscn"

func _on_restart_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_main_menu_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
