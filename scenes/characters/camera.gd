class_name Camera
extends Character

@export var shoot_interval: float = 2.0
@export var flight_height: float = 100.0
@export var filme_scene: PackedScene 

var target: Player
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	super._ready()
	target = get_tree().get_first_node_in_group("player")
	
	shoot_timer.wait_time = shoot_interval
	shoot_timer.one_shot = false 
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.start()

func handle_input() -> void:
	if not target or not can_move():
		velocity = Vector2.ZERO
		return
	
	var target_pos = target.global_position
	target_pos.y -= flight_height 
	
	var direction = (target_pos - global_position).normalized()
	velocity = direction * speed
	
func _fire_projectile():
	if filme_scene:
		var filme = filme_scene.instantiate() as Filme
		get_tree().root.add_child(filme)
		filme.global_position = self.global_position + Vector2(0, 50)
		var launch_direction = (target.global_position - filme.global_position).normalized()
		filme.launch(launch_direction * 400)

func _on_shoot_timer_timeout() -> void:
	if not can_attack():
		return
	state = State.ATTACK
