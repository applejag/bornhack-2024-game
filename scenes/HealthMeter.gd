extends TextureProgressBar

@onready var label: Label = get_node("Label")

func _ready() -> void:
	update_value(int(max_value))

func update_value(health: int) -> void:
	value = health
	label.text = "%d / %d" % [health, max_value]

func _on_player_health_changed(_old_health: int, new_health: int) -> void:
	update_value(new_health)
