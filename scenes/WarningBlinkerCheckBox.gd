extends CheckBox

func _on_toggled(toggled_on: bool) -> void:
	var blinkers: WarningBlinkers = get_node("/root/world/Player/WarningBlinkers") as WarningBlinkers
	if toggled_on:
		blinkers.warn_blinkers_enable()
	else:
		blinkers.warn_blinkers_disable()
