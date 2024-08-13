extends Sprite2D

@onready var parent: Node2D = $".."

@export var maxLength = 50
@export var deadzone = 5

var pressing = false
var last_direction = Vector2.ZERO


func _ready():
	maxLength *= parent.scale.x

func _process(delta):
	if pressing:
		var direction = get_global_mouse_position() - parent.global_transform.origin
		
		if get_global_mouse_position().distance_to(parent.global_transform.origin) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			# Para poder moverlo incluso si el dedo está fuera del joystick
			var angle = parent.global_transform.origin.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_transform.origin.x + cos(angle) * maxLength
			global_position.y = parent.global_transform.origin.y + sin(angle) * maxLength 
		
		#calculateVector()
		handle_input(direction)
	else: 
		global_position = lerp(global_position, parent.global_transform.origin, delta * 40)
		parent.posVector = Vector2.ZERO
		release_all_inputs()

#func calculateVector():
	#if abs(global_position.x - parent.global_transform.origin.x) >= deadzone:
		#parent.posVector.x = (global_position.x - parent.global_transform.origin.x) / maxLength
	#if abs(global_position.y - parent.global_transform.origin.y) >= deadzone:
		#parent.posVector.y = (global_position.y - parent.global_transform.origin.y) / maxLength


func handle_input(direction):
	var current_direction = Vector2.ZERO

	# Determina las direcciones basadas en el ángulo del joystick
	if direction.x < -deadzone:
		current_direction.x = -1
		Input.action_press("move_left")
	else:
		Input.action_release("move_left")

	if direction.x > deadzone:
		current_direction.x = 1
		Input.action_press("move_right")
	else:
		Input.action_release("move_right")

	if direction.y < -deadzone:
		current_direction.y = -1
		Input.action_press("move_up")
	else:
		Input.action_release("move_up")

	if direction.y > deadzone:
		current_direction.y = 1
		Input.action_press("move_down")
	else:
		Input.action_release("move_down")

	last_direction = current_direction


func release_all_inputs():
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("move_up")
	Input.action_release("move_down")


func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false
	release_all_inputs()
