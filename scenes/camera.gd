extends Node3D

@export var rotate_speed: float = 5
@export_range(0, 1) var position_y_factor: float = 0.3
@export_range(0, 1) var look_at_y_factor: float = 0.3

@onready var player: Player = get_node("..")

func _process(delta):
	position = player.position
	position.y *= position_y_factor

	var player_velocity = player.linear_velocity
	player_velocity.y = 0 # ignore up/down movement
	if player_velocity.length() > 0.01:
		var target_position = player.position + player_velocity
		target_position.y *= look_at_y_factor
		var new_transform = transform.looking_at(target_position)
		transform  = transform.interpolate_with(new_transform, rotate_speed * delta)
