class_name BulletShooting
extends Node3D

@export var bullet: PackedScene = preload("res://scenes/bullet.tscn")
@export var bullet_speed: float = 100

func fire() -> void:
	var clone: Bullet = bullet.instantiate() as Bullet;
	get_tree().root.add_child(clone)
	clone.global_position = global_position
	clone.global_rotation = global_rotation
	clone.linear_velocity = -global_basis.z * bullet_speed
