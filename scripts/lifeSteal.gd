extends Sprite2D

var SPEED = 5
var ANGLE

@onready var players = get_tree().get_nodes_in_group("player")
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(.25).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	players = get_tree().get_nodes_in_group("player")
	player = players[0]
	ANGLE = get_angle_to(player.global_position)
	position.x += cos(ANGLE) * SPEED
	position.y += sin(ANGLE) * SPEED

func init(newPos):
	global_position = newPos
