extends CanvasLayer


func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
