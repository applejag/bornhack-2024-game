class_name DamageDealer
extends Node

@export var damage: int = 1

func _on_body_entered(body: Node) -> void:
	var health: Health = body.find_child("Health") as Health
	if health:
		health.deal_damage(damage)
