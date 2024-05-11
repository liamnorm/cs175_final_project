extends Node3D

var chunk_scene = preload("res://Chunk.tscn")
#var entity_scene = preload("res://Entity.tscn")

var load_radius = 5
@onready var chunks = $Chunks
@onready var player = $Player
@onready var entities = $Entities

@onready var pauseMenu = $PauseMenu


var load_thread = Thread.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# instantiate chunks
	for i in range(0, load_radius):
		for j in range(0, load_radius):
			var chunk = chunk_scene.instantiate()
			chunk.set_chunk_position(Vector2(i, j))
			chunks.add_child(chunk)
	
	# instantiate entities
#	for i in range(0, 10):
#		for j in range(0, 10):
#			var entity = entity_scene.instantiate()
#			entity.setup(Vector3(i*5, 32, j*5), "tex_plant")
#			entities.add_child(entity)

	load_thread.start(_thread_process)
	
	$Crosshair.position = get_viewport().size / 2
	
	player.break_block.connect(break_block)
	player.place_block.connect(place_block)

func _thread_process():
	while true:
		for c in chunks.get_children():
			var cx = c.chunk_position.x
			var cz = c.chunk_position.y
			
			
			var px = floor(player.position.x / Globals.DIMENSION.x)
			var pz = floor(player.position.z / Globals.DIMENSION.z)
			
			var new_x = posmod(cx - px + load_radius/2, load_radius) + px - load_radius / 2
			var new_z = posmod(cz - pz + load_radius/2, load_radius) + pz- load_radius / 2
			
			if (new_x != cx or new_z != cz):
				c.set_chunk_position(Vector2(int(new_x), int(new_z)))
				c.generate()
				c.update()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("pause"):
		pauseMenu.show()
		get_tree().paused = true

		

func get_chunk(chunk_pos):
	for c in chunks.get_children():
		if c.chunk_position == chunk_pos:
			return c
	return null
	
func place_block(pos, t):
	var cx = int(floor(pos.x / Globals.DIMENSION.x))
	var cz = int(floor(pos.z / Globals.DIMENSION.z))
	
	var bx = posmod(floor(pos.x), Globals.DIMENSION.x)
	var by = posmod(floor(pos.y), Globals.DIMENSION.y)
	var bz = posmod(floor(pos.z), Globals.DIMENSION.z)
	
	var c = get_chunk(Vector2(cx, cz))
	
	if c != null:
		c.blocks[bx][by][bz] = t
		c.update()
		
func break_block(pos):
	place_block(pos, Globals.AIR)
