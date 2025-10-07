extends Area2D

@export var heal_amount: int


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.recover_health(heal_amount)
		queue_free()
