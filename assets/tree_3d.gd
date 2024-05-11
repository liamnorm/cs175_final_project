extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = not Globals.roundearth
	
func set_tree_position(pos):
	position = Vector3(pos.x + 0.5, pos.y + 2.7, pos.z + 0.5)
