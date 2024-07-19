class_name Player
extends VehicleBody3D

@export var max_speed: float = 30
@export_range(0, 1) var reverse_speed_factor: float = 0.3
@export var acceleration: float = 5
@export var brake_force: float = 1

@export_range(0, 90) var steer_angle: float = 30
@export var steer_speed: float = 1

@export var jump_force: float = 100
@export var jump_angular: float = 50
@export var jump_max_y: float = 0.15

@onready var reset_car_timer: Timer = get_node("ResetCarDebounce")
var can_reset_car: bool = true

@onready var reset_jump_timer: Timer = get_node("ResetJumpDebounce")
var can_jump: bool = true

func _process(delta: float) -> void:
	var current_velocity = linear_velocity
	var forward_mps = (current_velocity * transform.basis).x
	var current_speed = current_velocity.length()

	if Input.is_action_pressed("move_forward"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if current_speed < acceleration and current_speed != 0:
			engine_force = clamp(max_speed * acceleration / current_speed, 0, 100)
		else:
			engine_force = max_speed
	else:
		engine_force = 0

	if Input.is_action_pressed("move_back"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if forward_mps >= -1:
			if current_speed < acceleration and current_speed != 0:
				engine_force = -clamp(max_speed * reverse_speed_factor * acceleration / current_speed, 0, 100)
			else:
				engine_force = -max_speed * reverse_speed_factor
		else:
			brake = brake_force
	else:
		brake = 0.0

	var target_steering = Input.get_axis("steer_right", "steer_left") * steer_angle
	steering = deg_to_rad(clamp(
		move_toward(rad_to_deg(steering), target_steering, steer_speed * delta),
		-steer_angle,
		steer_angle))

	if Input.is_action_just_pressed("jump") and position.y < jump_max_y and can_jump:
		linear_velocity.y = jump_force
		var added_angular = Vector3.RIGHT * -jump_angular * transform.basis.inverse()
		angular_velocity += added_angular
		can_jump = true
		reset_jump_timer.start()

	if Input.is_action_just_pressed("reset_car") and can_reset_car:
		rotation = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		linear_velocity = Vector3.ZERO
		position += Vector3.UP * 0.5
		can_reset_car = false
		reset_car_timer.start()

func _on_reset_car_debounce_timeout():
	can_reset_car = true

func _on_reset_jump_debounce_timeout():
	can_jump = true
