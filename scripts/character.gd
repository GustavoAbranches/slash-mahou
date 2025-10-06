#OS COMENTARIOS SO SERÃO RETIRADOS QUANDO AS ANIMAÇOES ESTIVEREM PRONTAS
class_name Character
extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float 

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite 
@onready var damage_emitter := $DamageEmitter

enum State {IDLE, WALK, ATTACK}

var state = State.IDLE
const GAME_OVER_SCREEN = preload("res://scenes/ui/game_over_screen.tscn")

func _ready() -> void:
	print(name, " está tentando conectar o sinal do DamageEmitter.")
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	print(name, " conectou emitter -> on_emit_damage")

func _physics_process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	flip_sprites()
	move_and_slide()
	
#CONTROLA A ANIMAÇÃO DE MOVIMENTO
func  handle_movement() -> void:
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
		target_character.take_damage(damage)
		print("Dano aplicado em ", target_character.name, " nova vida: ", target_character.health)

func take_damage(amount: int) -> void:
	if health <= 0:
		return
		
	health -= amount
	print(name, " recebeu ", amount, " de dano. Vida restante: ", health)
	
	if health <= 0:
		die()
		
func die() -> void:	
	velocity = Vector2.ZERO
	set_process(false)
	
	if self is Player:
		var game_over_screen = GAME_OVER_SCREEN.instantiate()
		get_tree().root.add_child(game_over_screen)
	
	queue_free()
