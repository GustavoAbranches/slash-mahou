class_name Acao

extends Character

@export var change_dir_time: float = 3.0
@export var damage_cooldown: float = 1.0

var direction: int = 1

@onready var turn_timer: Timer = $TurnTimer
@onready var damage_cooldown_timer: Timer = $DamageCooldownTimer

func _ready() -> void:
	super._ready()
	
	turn_timer.wait_time = change_dir_time
	turn_timer.one_shot = false
	turn_timer.timeout.connect(_on_turn_timer_timeout)
	turn_timer.start()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if not damage_cooldown_timer.is_stopped():
		return
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision and collision.get_collider().is_in_group("player"):
			var player_node = collision.get_collider()
			player_node.take_damage(damage, self.global_position)
			damage_cooldown_timer.start(damage_cooldown)
			break

func handle_input() -> void:
	if not can_move():
		velocity = Vector2.ZERO
		return
	
	velocity.x = direction * speed

func _on_turn_timer_timeout() -> void:
	direction *= -1
