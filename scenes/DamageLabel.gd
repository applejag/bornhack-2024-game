class_name DamageLabel
extends Label3D

@export var linear_velocity: Vector3
@export var fade_opacity_time: float = 1

func _ready():
	var tween = get_tree().create_tween()
	var target_modulate = modulate
	target_modulate.a = 0
	tween.parallel().tween_property(self, "modulate", target_modulate, fade_opacity_time)
	var target_outline_modulate = outline_modulate
	target_outline_modulate.a = 0
	tween.parallel().tween_property(self, "outline_modulate", target_outline_modulate, fade_opacity_time)
	tween.tween_callback(queue_free)

func _process(delta):
	global_position += linear_velocity * delta
