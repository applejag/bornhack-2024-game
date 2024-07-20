class_name Health
extends Node

@export_range(0, 100, 1, "max_health") var health: int = 100
@export var max_health: int = 100

signal health_changed(old_health: int, new_health: int)
signal health_depleted()

func deal_damage(damage: int = 1) -> void:
	var old_health = health
	health -= damage
	health_changed.emit(old_health, health)
	if health <= 0:
		health = 0
		health_depleted.emit()
