extends Control

signal toggle_RoundEarth

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed():
	hide()
	get_tree().paused = false

func _on_round_earth_pressed():
	toggle_RoundEarth.emit()
