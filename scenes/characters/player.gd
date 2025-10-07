class_name Player

extends Character

@onready var health_bar: ProgressBar = $CanvasLayer/HeathBar

var max_health: int

const GAME_OVER_SCREEN = preload("res://scenes/ui/game_over_screen.tscn")

func _ready() -> void:
	super()
	max_health = health
	health_bar.max_value = max_health
	health_bar.value = health
	
	health_changed.connect(_on_health_changed)

func handle_input() -> void: 
	if state == State.HIT:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func recover_health(amount: int) -> void:
	health += amount
	health = min(health, max_health)
	health_changed.emit(health)
	print("Vida recuperada! Vida atual: ", health)

func die() -> void:
	super.die() 
	var game_over_screen = GAME_OVER_SCREEN.instantiate()
	get_tree().root.add_child(game_over_screen)
