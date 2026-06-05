extends CharacterBody2D

@export_enum("left_up", "right_up", ) var up_action: String
@export_enum("left_down", "right_down") var down_action: String
@export var paddle_speed: float = 1000
@export var paddle_height: float = 1.2

func _ready():
	global_scale.y = paddle_height
	
func _physics_process(_delta: float) -> void:
	velocity.y = 0
	if Input.is_action_pressed(up_action):
		velocity.y = -paddle_speed
	elif Input.is_action_pressed(down_action):
		velocity.y = paddle_speed
	move_and_slide()
