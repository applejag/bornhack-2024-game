class_name DamageDealer
extends Node

@export var damage: int = 1
@export var damage_label: PackedScene = preload("res://scenes/damage_label.tscn")

func _on_body_entered(body: Node) -> void:
	var health: Health = body.find_child("Health") as Health
	if health:
		health.deal_damage(damage)

	var node3d = body as Node3D
	if node3d:
		var clone = damage_label.instantiate() as DamageLabel
		clone.global_position = node3d.global_position
		clone.text = "-%d" % damage
		get_tree().root.add_child(clone)
