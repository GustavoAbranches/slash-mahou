class_name Slime
extends Character

var player : Player

func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("player")


func handle_input() -> void: 
	if player != null:
		var direction := (player.position - position).normalized() 
		velocity = direction * speed
