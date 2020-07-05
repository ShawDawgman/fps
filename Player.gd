extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
export var health = 5
const MAX_SPEED = 45
const ACCEL = 3

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

onready var weapon = $Head/Camera/ui/weapon
onready var healthBar = $Head/Camera/ui/health

onready var head = $Head
onready var camera = $Head/Camera
var camera_x_rotation = 0
export var mouse_sensitivity = 0.3


func _update_ui():
	healthBar.text = "Health: " + String(health)	

func _ready():
	healthBar.text = "Health: " + String(health)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		#if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			#camera.rotate_x(deg2rad(-x_delta))
			#camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("Forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("Backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("Left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("Right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
