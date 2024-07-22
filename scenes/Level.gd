class_name Level
extends Resource

@export var spawn_waves: Array[int]

func get_total_spawn_count() -> int:
	var count: int = 0
	for wave in spawn_waves:
		count += wave
	return count
