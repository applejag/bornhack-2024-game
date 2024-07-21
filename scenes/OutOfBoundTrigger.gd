class_name OutOfBoundsTrigger
extends Node3D

@export var max_position: Vector3 = 100 * Vector3.ONE
@export var min_position: Vector3 = -100 * Vector3.ONE

signal out_of_bounds()

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = false
	add_child(timer)
	timer.start()

	timer.connect("timeout", self._on_timer_timeout)

func _on_timer_timeout() -> void:
	var current = global_position
	if current.x < min_position.x \
		or current.y < min_position.y \
		or current.z < min_position.z \
		or current.x > max_position.x \
		or current.y > max_position.y \
		or current.z > max_position.z:
		out_of_bounds.emit()
