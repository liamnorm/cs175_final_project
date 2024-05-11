extends CharacterBody3D

const CROUCH_SPEED  = 2.5
const WALK_SPEED    = 5.0
const RUN_SPEED     = 7.5
const JUMP_VELOCITY = 7.5
const EYE_HEIGHT    = 1.0

var is_crouching : bool = false

var SPAWN = Vector3(0, 64, 0)

var mouse_sensitivity = 0.1

var camera_x_rotation = 0

@onready var camera = $Head/Camera
@onready var head = $Head

@onready var raycast = $Head/Camera/Raycast
@onready var block_outline = $BlockOutline

signal break_block(pos)
signal place_block(pos, t)

var gravity = 25.0

func _ready():
	position = SPAWN
	
	raycast.add_exception(self)

func _process(delta):
	
	camera.position = Vector3(0, EYE_HEIGHT, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("crouch"):
		toggle_crouch()

	if event is InputEventMouseMotion:
		$Head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var delta_x = mouse_sensitivity * event.relative.y
		if camera_x_rotation + delta_x > -90 and camera_x_rotation + delta_x < 90:
			camera.rotate_x(deg_to_rad(-delta_x))
			camera_x_rotation += delta_x
			

func _physics_process(delta):
	
	if position.y < 0:
		position = SPAWN
		velocity = Vector3(0,0,0)
		
	var y_change = velocity.y
	
	if not is_on_floor():
		y_change -= gravity * delta

	if Input.is_action_pressed("space") and is_on_floor():
		y_change = JUMP_VELOCITY
	
	# run while 'q' is pressed
	var speed = 0.0
	if is_crouching:
		speed = CROUCH_SPEED
	elif Input.is_action_pressed("run"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
	
	var x_change = (int(Input.is_action_pressed("d")) - int(Input.is_action_pressed("a"))) * speed
	var z_change = (int(Input.is_action_pressed("w")) - int(Input.is_action_pressed("s"))) * speed
	if x_change !=0 and z_change != 0:
		x_change *= .707
		z_change *= .707
	#var y_change = (int(Input.is_action_pressed("space")) - int(Input.is_action_pressed("shift"))) * strength


	var r = deg_to_rad($Head.rotation_degrees.y)
	velocity.z = cos(r) * -z_change + sin(r) * -x_change
	velocity.x = cos(r) * x_change + sin(r) * -z_change
	velocity.y = y_change

	move_and_slide()
	
	if raycast.is_colliding():
		var norm = raycast.get_collision_normal()
		var pos = raycast.get_collision_point() - norm * 0.5

		var bx = floor(pos.x) + 0.5
		var by = floor(pos.y) + 0.5
		var bz = floor(pos.z) + 0.5
		
		var bpos = Vector3(bx, by, bz) - self.position
		
		block_outline.position = bpos
		block_outline.visible = true
		
		if Input.is_action_just_pressed("break"):
			break_block.emit(pos)
		elif Input.is_action_just_pressed("place"):
			place_block.emit(pos+norm, Globals.STONE)
		
	else:
		block_outline.visible = false
		
func toggle_crouch():
	if is_crouching == true:
		$Head.translate(Vector3(0, 0.5, 0))
	elif is_crouching == false:
		$Head.translate(Vector3(0, -0.5, 0))
	is_crouching = !is_crouching
