extends RigidBody3D

@export var damage: int = 1
@export var spawn_on_collision: PackedScene

func _on_body_entered(_body: Node) -> void:
	if spawn_on_collision:
		var clone = spawn_on_collision.instantiate()
		clone.global_position = global_position

		var damager: DamageDealer = clone.find_child("DamageDealer")
		if damager:
			damager.damage = damage

		get_tree().root.add_child(clone)
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
