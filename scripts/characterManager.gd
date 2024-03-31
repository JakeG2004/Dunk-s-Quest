extends Node2D

@onready var knight = preload("res://scenes/objects/players/knight.tscn")
@onready var wizzer = preload("res://scenes/objects/players/wizzer.tscn")
@onready var elf = preload("res://scenes/objects/players/elf.tscn")

@onready var mapManager = get_parent().get_node("mapManager")

@export var chars = ["Knight", "Wizzer", "Elf"]

var rooms = []
var charPtr = 0
var currentChar = chars[charPtr]
var HEALTH = 100

var iTime = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(knight.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("change_char")):
		changeChar()
		
func damage(inDamage):
	if(!iTime):
		iTime = true
		HEALTH -= inDamage
		print(HEALTH)
		await get_tree().create_timer(.5).timeout
		iTime = false
		
func heal(inHeal):
	HEALTH = clamp(HEALTH + inHeal, HEALTH, 100)
	print(HEALTH)
	
func addRoom(room):
	for child in mapManager.get_children():
		if(child not in rooms):
			rooms.append(child)
	
func isTile(newPos):
	for room in rooms:
		if(room.isTile(newPos)):
			return true

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
	
		"Elf":
			add_child(elf.instantiate())
			
	global_position = oldPos
