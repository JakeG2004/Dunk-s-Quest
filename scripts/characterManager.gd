extends Node2D

@onready var knight = preload("res://scenes/objects/players/knight.tscn")
@onready var wizzer = preload("res://scenes/objects/players/wizzer.tscn")

var chars = ["Knight", "Wizzer"]
var charPtr = 1
var currentChar = chars[charPtr]
var HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("change_char")):
		changeChar()

func changeChar():
	#Go to next character
	charPtr = (charPtr + 1) % chars.size()
	currentChar = chars[charPtr]
	
	var oldPos = get_child(0).global_position
	
	#delete all old children
	for child in get_children():
		child.queue_free()
	
	#actually switch character
	match currentChar:
		"Knight":
			add_child(knight.instantiate())
			
		"Wizzer":
			add_child(wizzer.instantiate())
			
	global_position = oldPos
