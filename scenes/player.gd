class_name Player
extends VehicleBody3D

@export_group("Moving")
@export var max_speed: float = 30
@export_range(0, 1) var reverse_speed_factor: float = 0.3
@export var acceleration: float = 5
@export var brake_force: float = 1

@export_group("Steering")
@export_range(0, 90) var steer_angle: float = 30
@export var steer_speed: float = 1

@export_group("Jumping")
@export var jump_force: float = 100
@export var jump_angular: float = 50
@export var jump_max_y: float = 0.15
@export var jump_revert_rotation_speed: float = 0.15
@export var jump_revert_factor_curve_time: float = 3
@export var jump_revert_factor_curve: Curve

@onready var reset_car_timer: Timer = get_node("ResetCarDebounce")
var can_reset_car: bool = true

@onready var reset_jump_timer: Timer = get_node("ResetJumpDebounce")
var can_jump: bool = true

enum JumpState { Grounded, Ascending, Falling }
var jump_state: JumpState = JumpState.Grounded
@onready var jump_last_y: float = position.y
var jump_state_time: float = 0;

@onready var forward_last_pos: Vector3 = position
var forward: Vector3 = Vector3.FORWARD

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
		jump()

	if Input.is_action_just_pressed("reset_car") and can_reset_car:
		reset_car()

func jump() -> void:
	linear_velocity.y = jump_force
	var added_angular = Vector3.RIGHT * -jump_angular * transform.basis.inverse()
	angular_velocity += added_angular
	can_jump = true
	reset_jump_timer.start()

	jump_state = JumpState.Ascending
	jump_last_y = position.y
	jump_state_time = 0
	print("ascending")

func reset_car() -> void:
	rotation = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	position += Vector3.UP * 0.5
	can_reset_car = false
	reset_car_timer.start()

func _physics_process(delta) -> void:
	var forward_delta = position - forward_last_pos
	forward_delta.y = 0
	if not forward_delta.is_zero_approx():
		forward = forward_delta.normalized()
		forward_last_pos = position

	jump_state_time += delta
	match jump_state:
		JumpState.Grounded:
			pass
		JumpState.Falling:
			if position.y >= jump_last_y:
				jump_state = JumpState.Grounded
				jump_state_time = 0
				print("grounded")
		JumpState.Ascending:
			if position.y <= jump_last_y:
				jump_state = JumpState.Falling
				jump_state_time = 0
				print("falling")
	jump_last_y = position.y

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if jump_state == JumpState.Falling:
		var target_rotation = Quaternion(Basis.looking_at(forward))
		var current_rotation = Quaternion(transform.basis)
		var curve_factor = jump_revert_factor_curve.sample(min(jump_state_time / jump_revert_factor_curve_time, 1))
		var new_rotation = current_rotation.slerp(target_rotation, clamp(state.step * jump_revert_rotation_speed * curve_factor, 0, 1))
		transform.basis = Basis(new_rotation)

func _on_reset_car_debounce_timeout() -> void:
	can_reset_car = true

func _on_reset_jump_debounce_timeout() -> void:
	can_jump = true
