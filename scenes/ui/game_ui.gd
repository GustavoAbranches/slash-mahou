extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var timer_label: Label = $TimerLabel
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	GameManager.score_updated.connect(update_score)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		health_bar.max_value = player.max_health
		health_bar.value = player.health
		player.health_changed.connect(update_health_bar)

func update_score(new_score: int) -> void:
	score_label.text = "%s" % new_score

func update_timer(time_left: int) -> void:
	timer_label.text = "%s" % time_left

# Nova função para atualizar a barra de vida
func update_health_bar(current_health: int) -> void:
	health_bar.value = current_health
