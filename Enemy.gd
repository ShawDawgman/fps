extends KinematicBody

onready var sprite = $Enemy/Sprite
var viewDistance = 5
var distanceToPlayer = 0
var vel = Vector3()
var gravity = 1
onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func findPlayer():
	
	print(distanceToPlayer)
	
func _physics_process(delta):
	pass
