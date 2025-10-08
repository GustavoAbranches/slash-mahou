class_name Character
extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float 
@export var knockback_force: float = 250.0
@export var health_pickup_scene: PackedScene
@export var drop_chance: float = 0.25
@export var points: int = 10

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite 
@onready var damage_emitter := $DamageEmitter
@onready var knockback_timer := $Knockback
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer

signal health_changed(new_health)

enum State {IDLE, WALK, ATTACK, HIT, DEATH}

var state = State.IDLE
var is_invulnerable := false

func _ready() -> void:
	knockback_timer.timeout.connect(on_knockback_finished)
	print(name, " está tentando conectar o sinal do DamageEmitter.")
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	invulnerability_timer.timeout.connect(_on_invulnerability_timer_timeout)
	print(name, " conectou emitter -> on_emit_damage")

func _physics_process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	flip_sprites()
	move_and_slide()
	
	if is_in_group("player") and is_invulnerable:
		character_sprite.visible = fmod(Time.get_ticks_msec(), 200) > 100
	else:
		character_sprite.visible = true
	
#CONTROLA A ANIMAÇÃO DE MOVIMENTO
func  handle_movement() -> void:
	if state == State.HIT:
		return
	if can_move():	
		if velocity.length() == 0:
			state= State.IDLE
		else: 
			state = State.WALK
	else:
		velocity = Vector2.ZERO

#DETECTA OS BOTÕES PRECIONADOS
func handle_input() -> void: 
	pass
			
#FUNÇÃO PARA ANIMAÇÕES
func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("Idle")
	elif state == State.WALK:
		animation_player.play("Walk")
	elif state == State.ATTACK:
		animation_player.play("Attack")
		
#INVERTE O SPRITE
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1 
		
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK 
	
func on_action_complete() -> void:
	state = State.IDLE
	
func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	print(name, " tentou causar dano em ", damage_receiver.name)
	if damage_receiver.get_parent() is Character:
		var target_character: Character = damage_receiver.get_parent()
		var attack_source_position = self.global_position
		target_character.take_damage(damage, attack_source_position)
		print("Dano aplicado em ", target_character.name, " nova vida: ", target_character.health)

func take_damage(damage: int, attack_source_position: Vector2) -> void:
	if is_invulnerable:
		return
	if health <= 0:
		return
		
	health -= damage
	health_changed.emit(health)
	print(name, " recebeu ", damage, " de dano. Vida restante: ", health)
	
	if health <= 0:
		die()
	else:
		
		if is_in_group("player"):
			is_invulnerable = true
			invulnerability_timer.start()
		
		state = State.HIT
		var knockback_direction = (global_position - attack_source_position).normalized()
		velocity = knockback_direction * knockback_force
		knockback_timer.start(0.2) #
		
func on_knockback_finished() -> void:
	if state == State.HIT:
		velocity = Vector2.ZERO
		state = State.IDLE
		
func _on_invulnerability_timer_timeout() -> void:
	is_invulnerable = false
	character_sprite.visible = true
	
func die() -> void:
	state = State.DEATH
	set_physics_process(false)
	animation_player.play("Death")
	await animation_player.animation_finished
	
#LÓGICA DE DROP
	if randf() < drop_chance:
		if health_pickup_scene:
			var pickup = health_pickup_scene.instantiate()
			get_parent().add_child(pickup)
			pickup.global_position = global_position
#PONTUAÇÃO
	GameManager.add_score(points)
	
	queue_free()
