class_name Player
extends VehicleBody3D

@export var max_speed: float = 30
@export_range(0, 1) var reverse_speed_factor: float = 0.3
@export var acceleration: float = 5
@export var brake_force: float = 1

@export_range(0, 90) var steer_angle: float = 30
@export var steer_speed: float = 1

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
