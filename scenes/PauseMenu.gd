extends Panel

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
