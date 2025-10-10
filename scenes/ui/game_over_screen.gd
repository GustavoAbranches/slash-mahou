extends CanvasLayer

const GAME_SCENE_PATH = "res://scenes/world.tscn"
const MENU_SCENE_PATH = "res://scenes/ui/main_menu.tscn"
@onready var final_score_label: Label = $Root/VBoxContainer/FinalScoreLabel

func _on_restart_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
	
func set_final_score(score: int) -> void:
	final_score_label.text = "Pontuação Final: %s" % score
