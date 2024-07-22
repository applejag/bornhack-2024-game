extends Node3D

@export var enemy_prefab: PackedScene = preload("res://scenes/tank1.tscn")
@export var spawn_points: Array[Marker3D] = []
@export var label_enemies: Label
@export var label_level: Label

@export var level_definitions: Array[Level] = []
@export var current_level: int = 0

@onready var timer_next_wave: Timer = get_node("TimerNextWave")
@onready var timer_next_level: Timer = get_node("TimerNextLevel")

var enemies_remaining: int = 0
var current_wave_index: int = 0

func _ready():
	update_labels()

func update_labels():
	label_enemies.text = "Enemies:\t%d" % enemies_remaining
	label_level.text = "Level:\t%d" % current_level

func start_level(new_level: int) -> void:
	current_level = new_level
	current_wave_index = 0
	var level: Level = level_definitions[current_level-1]
	enemies_remaining = level.get_total_spawn_count()
	spawn_wave(level.spawn_waves[0])
	timer_next_wave.start()
	update_labels()

func spawn_wave(spawn_count: int) -> void:
	spawn_points.shuffle()
	for i in range(spawn_count):
		var point: Marker3D = spawn_points[i]
		var clone = enemy_prefab.instantiate()
		clone.global_position = point.global_position
		get_parent().add_child(clone)
		clone.connect("tree_exiting", _on_enemy_tree_exiting)

func _on_timer_first_level_timeout():
	start_level(1)

func _on_timer_next_level_timeout():
	start_level(current_level + 1)

func _on_timer_next_wave_timeout():
	next_wave()

func next_wave() -> void:
	current_wave_index += 1
	var level: Level = level_definitions[current_level-1]
	if current_wave_index >= len(level.spawn_waves):
		return
	spawn_wave(level.spawn_waves[current_wave_index])
	timer_next_wave.start()

func _on_enemy_tree_exiting():
	enemies_remaining -= 1
	update_labels()

	if enemies_remaining <= 0:
		timer_next_level.start()
