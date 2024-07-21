extends HSlider

@export var bus_name: String = "Master"

func _ready():
	var sfx_index = AudioServer.get_bus_index(bus_name)
	value = db_to_value(AudioServer.get_bus_volume_db(sfx_index))
	print(bus_name, ": value set to 0-100: ", value)

	connect("value_changed", _on_slider_value_changed)

func _on_slider_value_changed(new_value: float) -> void:
	var sfx_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(sfx_index, value_to_db(new_value))
	AudioServer.set_bus_mute(sfx_index, new_value == 0)
	print(bus_name, ": value set to DB: ", value_to_db(new_value))

## Converts from 0-100 value to dB's
func value_to_db(val: float) -> float:
	return lerp(-80, 0, val / 100)

## Converts from dB's to 0-100 value
func db_to_value(val: float) -> float:
	return inverse_lerp(-80, 0, val) * 100
