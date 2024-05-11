@tool

extends StaticBody3D

@onready var optionsMenu = $OptionsMenu 

const vertices = [
	Vector3(0, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, 1, 0),
	Vector3(1, 1, 0),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1),
	Vector3(0, 1, 1),
	Vector3(1, 1, 1),
]

const TOP = [2,3,7,6]
const BOTTOM = [0,4,5,1]
const LEFT = [6,4,0,2]
const RIGHT = [3,1,5,7]
const FRONT = [7,5,4,6]
const BACK = [2,0,1,3]

var blocks = []


var st = SurfaceTool.new()
var mesh = null
var mesh_instance = null

var material = preload("res://assets/block_material.tres")

var chunk_position = Vector2(0,0)
var global_offset = Vector3(0,0,0)

var noise = FastNoiseLite.new()

func _ready():
	optionsMenu.toggle_RoundEarth.connect(_on_toggle_RoundEarth)
	#material.albedo_texture.set_flags(2)
	generate()
	update()

func _input(event):
	if event.is_action_pressed("options"):
		optionsMenu.show()
		get_tree().paused = true
	
func generate():
	blocks = []
	blocks.resize(Globals.DIMENSION.x)
	for i in range(0, Globals.DIMENSION.x):
		blocks[i] = []
		blocks[i].resize(Globals.DIMENSION.y)
		for j in range(0, Globals.DIMENSION.y):
			blocks[i][j] = []
			blocks[i][j].resize(Globals.DIMENSION.z)
			for k in range(0, Globals.DIMENSION.z):
				var block = Globals.AIR
				
				var global_pos = chunk_position * \
					Vector2(Globals.DIMENSION.x, Globals.DIMENSION.z) + \
					Vector2(i, k)
				var height = int((noise.get_noise_2dv(global_pos) + 1) / 2 * Globals.DIMENSION.y)
				
				if false:#j % 3 == 0:
					block = Globals.YELLOW_TILE
				
				elif j < height - 5:
					block = Globals.STONE
				elif j < height:
					block = Globals.DIRT
				elif j == height:
					block = Globals.GRASS
					if randf() < 0.01:
						block = Globals.WOOD
				elif j < 32:
					block = Globals.WATER
				
				blocks[i][j][k] = block


func update():
	if mesh_instance != null:
		mesh_instance.call_deferred("queue_free")
		mesh_instance = null
		
	mesh = ArrayMesh.new()
	mesh_instance = MeshInstance3D.new()
	st.begin(ArrayMesh.PRIMITIVE_TRIANGLES)
	
	for x in Globals.DIMENSION.x:
		for y in Globals.DIMENSION.y:
			for z in Globals.DIMENSION.z:
				create_block(x,y,z)
				
	st.generate_normals(false)
	st.set_material(material)
	st.commit(mesh)
	mesh_instance.set_mesh(mesh)
	
	add_child(mesh_instance)
	mesh_instance.create_trimesh_collision()
	
	self.visible = true

func check_transparent(x, y, z):
	if x >= 0 and x < Globals.DIMENSION.x and \
		y >= 0 and y < Globals.DIMENSION.y and \
		z >= 0 and z < Globals.DIMENSION.z:
		return not Globals.types[blocks[x][y][z]][Globals.SOLID]
	return true

func create_block(x, y, z):
	
	var block = blocks[x][y][z]
	if block == Globals.AIR:
		return
	
	var block_info = Globals.types[block]
		
	if check_transparent(x, y + 1, z):
		create_face(TOP, x, y, z, block_info[Globals.TOP])
	
	if check_transparent(x, y - 1, z):
		create_face(BOTTOM, x, y, z, block_info[Globals.BOTTOM])
	
	if check_transparent(x - 1, y, z):
		#if x> 0:
			create_face(LEFT, x, y, z, block_info[Globals.LEFT])

	if check_transparent(x + 1, y, z):
		#if x < Globals.DIMENSION.x - 1:
			create_face(RIGHT, x, y, z, block_info[Globals.RIGHT])
		
	if check_transparent(x, y, z - 1):
		create_face(BACK, x, y, z, block_info[Globals.BACK])

	if check_transparent(x, y, z + 1):
		create_face(FRONT, x, y, z, block_info[Globals.FRONT])


func create_face(l, x, y, z, texture_atlas_offset):
	var offset = Vector3(x,y,z) + global_offset
	var a = vertices[l[0]] + offset
	var b = vertices[l[1]] + offset
	var c = vertices[l[2]] + offset
	var d = vertices[l[3]] + offset
	
	var uv_offset = texture_atlas_offset / Globals.TEXTURE_ATLAS_SIZE
	var height = 1.0 / Globals.TEXTURE_ATLAS_SIZE.y
	var width = 1.0 / Globals.TEXTURE_ATLAS_SIZE.x
	
	var uv_a = uv_offset + Vector2(0, 0)
	var uv_b = uv_offset + Vector2(0, height)
	var uv_c = uv_offset + Vector2(width, height)
	var uv_d = uv_offset + Vector2(width, 0)
	
	st.set_smooth_group(-1)
	st.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
	st.add_triangle_fan(([a, c, d]), ([uv_a, uv_c, uv_d]))
	
func set_chunk_position(pos):
	
	self.visible = false
	chunk_position = pos
	position = Vector3(0,0,0) #Vector3(pos.x, 0, pos.y) * Globals.DIMENSION
	global_offset = Vector3(pos.x, 0, pos.y) * Globals.DIMENSION
	
func _on_toggle_RoundEarth():
	var toggle = !(material.get_shader_parameter("round_earth"))
	print("toggle")
	material.set_shader_parameter("round_earth", toggle)
	update()
