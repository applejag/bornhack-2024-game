extends Area3D

@export var scale_start: float = 0.1
@export var scale_end: float = 5
@export var scale_time_seconds: float = 1

func _ready():
	var tween = get_tree().create_tween()
	scale = Vector3.ONE * scale_start
	tween.tween_property(self, "scale", Vector3.ONE * scale_end, scale_time_seconds)
	tween.tween_property(self, "visible", false, 0)
	tween.tween_interval(0.4)
	tween.tween_callback(queue_free)
