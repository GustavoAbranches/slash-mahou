extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var timer_label: Label = $TimerLabel

func _ready() -> void:
	GameManager.score_updated.connect(update_score)

func update_score(new_score: int) -> void:
	score_label.text = "Score: %s" % new_score

func update_timer(time_left: int) -> void:
	timer_label.text = "Tempo: %s" % time_left
