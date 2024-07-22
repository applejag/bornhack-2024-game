class_name WarningBlinkers
extends Node3D

@onready var timer: Timer = get_node("Timer")

func warn_blinkers_enable():
	visible = true
	timer.start()

func warn_blinkers_disable():
	visible = false
	timer.stop()

func toggle_visibility():
	visible = not visible
