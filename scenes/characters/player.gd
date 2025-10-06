class_name Player

extends "res://scripts/character.gd"

@onready var health_bar: ProgressBar = $CanvasLayer/HeathBar

func _ready() -> void:
	super()
	health_bar.max_value = health
	health_bar.value = health
	
func _process(_delta: float) -> void:
	health_bar.value = health

func handle_input() -> void: 
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed
		if can_attack() and Input.is_action_just_pressed("attack"):
			state = State.ATTACK
