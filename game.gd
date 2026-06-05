extends Node2D

enum Starter {LEFT, RIGHT}
@onready var left_paddle: CharacterBody2D = $left_paddle
@onready var right_paddle: CharacterBody2D = $right_paddle
@onready var ball: CharacterBody2D = $ball
@onready var right_score: Label = $Scores/HBoxContainer/right_score
@onready var left_score: Label = $Scores/HBoxContainer/left_score

@export var paddle_speed: float = 1000
@export var starter: Starter = Starter.RIGHT
@export var ball_x_speed: float = 500
@export var ball_x_max_speed: float = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	right_score.text = str(0)
	left_score.text = str(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		if ball.velocity == Vector2.ZERO:
			var ball_speed = Vector2(ball_x_speed, randf_range(-200, 200))
			if starter == Starter.RIGHT:
				ball.velocity = ball_speed
			else:
				ball.velocity = -ball_speed
	if Input.is_action_pressed("restart"):
		ball.global_position = Vector2.ZERO
		ball.velocity = Vector2.ZERO
		right_score.text = str(0)
		left_score.text = str(0)
	
	left_paddle.velocity.y = 0
	if Input.is_action_pressed("left_up"):
		left_paddle.velocity.y = -paddle_speed
	elif Input.is_action_pressed("left_down"):
		left_paddle.velocity.y = paddle_speed
	
	right_paddle.velocity.y = 0
	if Input.is_action_pressed("right_up"):
		right_paddle.velocity.y = -paddle_speed
	elif Input.is_action_pressed("right_down"):
		right_paddle.velocity.y = paddle_speed
	
	left_paddle.move_and_slide()
	right_paddle.move_and_slide()
	ball.move_and_slide()
	
	for i in range(ball.get_slide_collision_count()):
		var collision = ball.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider == left_paddle:
			if ball.velocity.x < 0:
				ball.velocity.x = min(abs(ball.velocity.x) +100, ball_x_max_speed)
				ball.velocity.y = clamp((ball.position.y - left_paddle.position.y) * 10, -500, 500)
		elif collider == right_paddle:
			if ball.velocity.x > 0:
				ball.velocity.x = -min(abs(ball.velocity.x) +100, ball_x_max_speed)
				ball.velocity.y = clamp((ball.position.y - right_paddle.position.y) * 10, -500, 500)
		else:
			ball.velocity = ball.velocity.bounce(collision.get_normal())
			
		if abs(ball.velocity.y) < 50:
			ball.velocity.y = [-50, 50].pick_random()
		break
	
func _on_right_gate_body_entered(body: Node2D) -> void:
	if body == ball:
		left_score.text = str(int(left_score.text)+1)
		ball.velocity = Vector2.ZERO
		ball.global_position = Vector2.ZERO
		starter = Starter.RIGHT

func _on_left_gate_body_entered(body: Node2D) -> void:
	if body == ball:
		right_score.text = str(int(right_score.text)+1)
		ball.velocity = Vector2.ZERO
		ball.global_position = Vector2.ZERO
		starter = Starter.LEFT
