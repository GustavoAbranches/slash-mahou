# filme.gd
class_name Filme
extends RigidBody2D

@export var damage: int = 15

@onready var damage_area: Area2D = $DamageArea
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	# Conecta o sinal da ÁREA DE DANO (não mais do RigidBody)
	damage_area.body_entered.connect(_on_body_entered)
	# Conecta o sinal para quando o projétil sair da tela
	visibility_notifier.screen_exited.connect(queue_free)

func launch(initial_velocity: Vector2) -> void:
	linear_velocity = initial_velocity

# Esta função agora é chamada pela DamageArea
func _on_body_entered(body: Node) -> void:
	# A verificação continua a mesma, mas agora a colisão física é ignorada
	if body.is_in_group("player"):
		body.take_damage(damage, global_position)
	
	# Destrói o projétil assim que ele causa dano
	queue_free()
