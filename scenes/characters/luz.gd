class_name Luz
extends Character

@export var attack_range: float = 150.0
@export var attack_cooldown: float = 2.0

var target: Player

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	super._ready()
	target = get_tree().get_first_node_in_group("player")

func handle_input() -> void:
	if not target or not can_move():
		velocity = Vector2.ZERO
		return

	var distance_to_target = global_position.distance_to(target.global_position)

	if distance_to_target <= attack_range:
		velocity = Vector2.ZERO
		if cooldown_timer.is_stopped() and can_attack():
			state = State.ATTACK
			cooldown_timer.start(attack_cooldown)
	else:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
# Sobrescreve a função original para adicionar a lógica de virar para o alvo
func flip_sprites() -> void:
	# Primeiro, executa a lógica original da classe pai (virar com a velocidade)
	super.flip_sprites()
	
	# Agora, adiciona a nova lógica específica para o inimigo Luz
	# Se não estiver se movendo E tiver um alvo, vira na direção do alvo
	if velocity.x == 0 and target:
		if target.global_position.x < self.global_position.x:
			character_sprite.flip_h = true
			damage_emitter.scale.x = -1
		else:
			character_sprite.flip_h = false
			damage_emitter.scale.x = 1
