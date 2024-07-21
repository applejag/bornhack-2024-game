class_name EnemyShootingThrottle
extends Node

static var instance: EnemyShootingThrottle

var callbacks: Array[Callable] = []
var can_shoot = true
@onready var timer: Timer = get_node("Timer")

func _ready() -> void:
	instance = self

func _process(_delta: float) -> void:
	if can_shoot and len(callbacks) > 0:
		can_shoot = false
		timer.start()

		var index = randi() % len(callbacks)
		callbacks[index].call()
		callbacks.remove_at(index)
		print("actually shoot")

func queue_fire(fire_function: Callable) -> void:
	# Remove it first to make sure we only have 1 of it
	callbacks.erase(fire_function)
	callbacks.append(fire_function)
	print("queue_fire")

func _on_timer_timeout() -> void:
	can_shoot = true