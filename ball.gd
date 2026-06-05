extends CharacterBody2D

@onready var left_paddle: CharacterBody2D = $"../left_paddle"
@onready var right_paddle: CharacterBody2D = $"../right_paddle"

@export var ball_x_max_speed: float = 1000
@export var ball_x_speed: float = 500

# Signal is used in game.gd for score logic
signal scored(player)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	# --- Bounce Logic ---
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider == left_paddle:
			if velocity.x < 0:
				velocity.x = min(abs(velocity.x) +100, ball_x_max_speed)
				velocity.y = clamp((position.y - left_paddle.position.y) * 10, -500, 500)
		elif collider == right_paddle:
			if velocity.x > 0:
				velocity.x = -min(abs(velocity.x) +100, ball_x_max_speed)
				velocity.y = clamp((position.y - right_paddle.position.y) * 10, -500, 500)
		else:
			velocity = velocity.bounce(collision.get_normal())
			
		if abs(velocity.y) < 50:
			velocity.y = [-50, 50].pick_random()
		break

# Functions are used in game.gd
func start_round(starter):
	if velocity == Vector2.ZERO:
			var ball_speed = Vector2(ball_x_speed, randf_range(-200, 200))
			if starter:
				velocity = -ball_speed
			else:
				velocity = ball_speed

func reset():
	velocity = Vector2.ZERO
	global_position = Vector2.ZERO

func _on_right_gate_body_entered(body: Node2D) -> void:
	if body == self:
		scored.emit(0)

func _on_left_gate_body_entered(body: Node2D) -> void:
	if body == self:
		scored.emit(1)
