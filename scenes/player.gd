class_name Player
extends VehicleBody3D

@export var speed: float = 30
@export var brake_force: float = 30

@export_range(0, 90) var steer_angle: float = 30
@export var steer_speed: float = 1

func _process(delta: float) -> void:
    engine_force = speed if Input.is_action_pressed("move_forward") else 0.0
    brake = brake_force if Input.is_action_pressed("move_back") else 0.0

    var target_steering = Input.get_axis("steer_right", "steer_left") * steer_angle
    steering = deg_to_rad(clamp(
        lerp(rad_to_deg(steering), target_steering, steer_speed * delta),
        -steer_angle,
        steer_angle))
