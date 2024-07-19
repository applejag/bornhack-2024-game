extends TextureProgressBar

@export var player: Player;
@export var speed_label: Label;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var speed_mps = player.linear_velocity.length()
	var speed_kph = speed_mps * 3600 / 1000
	value = speed_kph
	speed_label.text = "%d km/h" % int(speed_kph)
