class_name Slime
extends Character

@export var player : Player
@export var attack_range : float = 200.0
@export var lunge_speed_multiplier : float = 2.5

@onready var attack_cooldown: Timer = $AttackCooldown
@onready var lunge_duration: Timer = $LungeDuration

var _can_attack := true

func _ready() -> void:
	super()
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	lunge_duration.timeout.connect(_on_lunge_duration_timeout)

func handle_input() -> void:
	if player == null or state == State.HIT or state == State.ATTACK:
		return

	var direction_to_player := player.global_position - global_position
	var distance_to_player = direction_to_player.length()

	if distance_to_player <= attack_range and _can_attack:
		lunge_at_player(direction_to_player.normalized())
	elif state != State.ATTACK: 
		velocity = direction_to_player.normalized() * speed

func lunge_at_player(direction: Vector2) -> void:
	state = State.ATTACK
	_can_attack = false
	
	velocity = direction * speed * lunge_speed_multiplier
	
	lunge_duration.start()
	attack_cooldown.start()

func _on_lunge_duration_timeout() -> void:
	velocity = Vector2.ZERO
	state = State.IDLE

func _on_attack_cooldown_timeout() -> void:
	_can_attack = true
