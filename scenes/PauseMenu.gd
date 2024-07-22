extends Panel

@export var main: PackedScene = preload("res://scenes/main.tscn")
@export var world: PackedScene = preload("res://scenes/world.tscn")

var is_paused: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			unpause()
		else:
			pause()

func pause() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true

func unpause() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false

func restart_level() -> void:
	var old_world = get_node("/root/world")
	old_world.queue_free()
	old_world.name = "old_world"
	call_deferred("spawn_scene", world)
	unpause()

func return_to_main_menu() -> void:
	var old_world = get_node("/root/world")
	old_world.queue_free()
	old_world.name = "old_world"
	call_deferred("spawn_scene", main)
	unpause()

func spawn_scene(scene: PackedScene) -> void:
	var clone = scene.instantiate()
	get_tree().root.add_child(clone)
