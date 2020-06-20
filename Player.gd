extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("Forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("Backward"):
		direction += head_basis.z
	
	if Input.is_action_pressed("Left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("Right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	
	velocity = move_and_slide(velocity, Vector3.UP)