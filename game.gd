extends Node2D

@onready var ball: CharacterBody2D = $ball
@onready var right_score: Label = $Scores/HBoxContainer/right_score
@onready var left_score: Label = $Scores/HBoxContainer/left_score

# right_paddle = 0, left_paddle = 1
var starter: int = 0

func _ready() -> void:
	ball.scored.connect(_on_player_scored)
	right_score.text = str(0)
	left_score.text = str(0)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		ball.start_round(starter)
	if Input.is_action_pressed("restart"):
		ball.reset()
		right_score.text = str(0)
		left_score.text = str(0)

# --- Score Logic ---
func _on_player_scored(player):
	starter = player
	ball.reset()
	if player:
		right_score.text = str(int(right_score.text)+1)
	else:
		left_score.text = str(int(left_score.text)+1)
