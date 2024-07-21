class_name Tank
extends CharacterBody3D

@export var min_dist_to_player: float = 10
@export var max_dist_to_player: float = 30
@export var max_speed: float = 5
@export var acceleration: float = 5
@export var rotation_speed: float = 5

@onready var player = get_node("/root/main/world/Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var vector_to_player = player.global_position - global_position

	var angle_to_player_rad = atan2(vector_to_player.x, vector_to_player.z)
	rotation.y = rotate_toward(rotation.y, angle_to_player_rad, deg_to_rad(rotation_speed) * delta)

	vector_to_player.y = 0
	var dist_to_player = vector_to_player.length()
	var target_speed = 0
	if dist_to_player < min_dist_to_player:
		# Move away from player
		target_speed = -max_speed
	elif dist_to_player > max_dist_to_player:
		# Move towards from player
		target_speed = max_speed
	else:
		# Stand still
		target_speed = 0

	var forward = basis.z
	velocity.x = move_toward(velocity.x, forward.x * target_speed, acceleration * delta)
	velocity.z = move_toward(velocity.z, forward.z * target_speed, acceleration * delta)

	move_and_slide()

# Triggered when out of bounds or when health is depleted
func _on_death():
	queue_free()
