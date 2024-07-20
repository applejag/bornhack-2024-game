extends Node3D

@export var bullet: PackedScene = preload("res://scenes/bullet.tscn")
@export var bullet_speed: float = 100

func _process(_delta) -> void:
	if Input.is_action_just_pressed("fire"):
		fire()

func fire() -> void:
	var clone: RigidBody3D = bullet.instantiate() as RigidBody3D;
	get_tree().root.add_child(clone)
	clone.global_position = global_position
	clone.global_rotation = global_rotation
	clone.linear_velocity = -global_basis.z * bullet_speed
