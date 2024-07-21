extends Panel

signal os_web()
signal os_linux()
signal os_macos()
signal os_windows()

signal start_game()

@export var world: PackedScene = preload("res://scenes/world.tscn")

func _ready():
	match OS.get_name():
		"Windows":
			os_windows.emit()
		"macOS":
			os_macos.emit()
		"Linux":
			os_linux.emit()
		"Web":
			os_web.emit()

func do_start_game():
	start_game.emit()
	var clone = world.instantiate()
	get_tree().root.add_child(clone)

func do_exit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_button_start_button_down():
	do_start_game()

func _on_button_exit_button_down():
	do_exit_game()
