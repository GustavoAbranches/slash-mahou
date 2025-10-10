class_name Player

extends Character

var max_health: int

const GAME_OVER_SCREEN = preload("res://scenes/ui/game_over_screen.tscn")

func _ready() -> void:
	super()
	max_health = health	
	health_changed.connect(_on_health_changed)

func handle_input() -> void: 
	if state == State.HIT:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK

func _on_health_changed(_new_health: int) -> void:
	pass

func recover_health(amount: int) -> void:
	health += amount
	health = min(health, max_health)
	health_changed.emit(health)
	print("Vida recuperada! Vida atual: ", health)

func die() -> void:
	super.die() 
	var game_over_screen = GAME_OVER_SCREEN.instantiate()
	get_tree().root.add_child(game_over_screen)
