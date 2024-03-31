extends Node2D

@onready var spawn = preload("res://scenes/rooms/spawn.tscn")
@onready var room1 = preload("res://scenes/rooms/room1.tscn")
@onready var boss = preload("res://scenes/rooms/boss.tscn")

@export var dimension = 5

var mapBP = []

const CELL_WIDTH = 224 # 16 * 14
const CELL_HEIGHT = 144 # 16 * 9

enum
{
	SPAWN,
	ROOM,
	BOSS
}

enum
{
	NORTH,
	SOUTH,
	EAST,
	WEST
}

@onready var numRooms = 10

class cell:
	var pos = Vector2.ZERO
	var type = null
	
	#constructor
	func _init(x, y):
		pos = Vector2(x * CELL_WIDTH - (2 * CELL_WIDTH), y * CELL_HEIGHT - (2 * CELL_HEIGHT))

# Called when the node enters the scene tree for the first time.
func _ready():
	if(numRooms + 2 > (dimension * dimension)):
		print("ERROR: TOO MANY ROOMS!")
		return
	
	#init blueprint
	for i in range(dimension):
		mapBP.append([])
		for j in range(dimension):
			mapBP[i].append(cell.new(i, j))
			
	var currentPos = Vector2(dimension / 2, dimension / 2)
	
	# set spawn room
	mapBP[currentPos.x][currentPos.y].type = SPAWN
	
	while(numRooms > 0):
		
		if(numRooms % 2 == 0):
			currentPos = findAvailableNodePos()
			mapBP[currentPos.x][currentPos.y].type = ROOM
			numRooms -= 1
			
		var direction = randi_range(0, 3)
		
		#Build initial rooms
		match(direction):
			NORTH:
				if(currentPos.y - 1 >= 0 and mapBP[currentPos.x][currentPos.y - 1].type == null):
					currentPos.y -= 1
					mapBP[currentPos.x][currentPos.y].type = ROOM
					numRooms -= 1

			SOUTH:
				if(currentPos.y + 1 <= 4 and mapBP[currentPos.x][currentPos.y + 1].type == null):
					currentPos.y += 1
					mapBP[currentPos.x][currentPos.y].type = ROOM
					numRooms -= 1

			EAST:
				if(currentPos.x - 1 >= 0 and mapBP[currentPos.x - 1][currentPos.y].type == null):
					currentPos.x -= 1
					mapBP[currentPos.x][currentPos.y].type = ROOM
					numRooms -= 1

			WEST:
				if(currentPos.x + 1 <= 4 and mapBP[currentPos.x + 1][currentPos.y].type == null):
					currentPos.x += 1
					mapBP[currentPos.x][currentPos.y].type = ROOM
					numRooms -= 1

		if(countAvailableDirections(currentPos) == 0):
			currentPos = findAvailableNodePos()
			mapBP[currentPos.x][currentPos.y].type = ROOM
			numRooms -= 1

	currentPos = findAvailableNodePos()
	mapBP[currentPos.x][currentPos.y].type = BOSS
	
	makeMap()
	
func findAvailableNodePos():
	var x = randi_range(0, dimension - 1)
	var y = randi_range(0, dimension - 1)

	for i in range(x, dimension):
		for j in range(y, dimension):
			var MAX_NULLS = 3
			
			if(i == 0 or i == dimension - 1):
				MAX_NULLS -= 1
			if(j == 0 or j == dimension - 1):
				MAX_NULLS -= 1
				
			if(countAvailableDirections(Vector2(i, j)) >= 1 and countAvailableDirections(Vector2(i, j)) <= MAX_NULLS and mapBP[i][j].type == null):
				return Vector2(i, j)
				
			#if reached end of array without finding an available node, run it again
			if(i == dimension - 1 and j == dimension - 1):
				return findAvailableNodePos()

func countAvailableDirections(currentPos):
	var count = 0
	
	# Check available directions
	if currentPos.y - 1 >= 0 and mapBP[currentPos.x][currentPos.y - 1].type == null:
		count += 1
	if currentPos.y + 1 <= dimension - 1 and mapBP[currentPos.x][currentPos.y + 1].type == null:
		count += 1
	if currentPos.x - 1 >= 0 and mapBP[currentPos.x - 1][currentPos.y].type == null:
		count += 1
	if currentPos.x + 1 <= dimension - 1 and mapBP[currentPos.x + 1][currentPos.y].type == null:
		count += 1
	
	#print("COUNT: " + str(count))
	return count

	
func printBP():
	for row in mapBP:
		var row_string = ""
		for element in row:
			if(element.type != null):
				row_string += str(element.type) + "\t"
			else:
				row_string += "n\t"
		print(row_string)

func makeMap():
	var newCell
	
	for i in range(dimension):
		for j in range(dimension):
			if(mapBP[i][j].type == ROOM):
				newCell = room1.instantiate()
				newCell.position = mapBP[i][j].pos
				call_deferred("add_child", newCell)
				
			elif(mapBP[i][j].type == SPAWN):
				newCell = spawn.instantiate()
				newCell.position = mapBP[i][j].pos
				call_deferred("add_child", newCell)
				
			elif(mapBP[i][j].type == BOSS):
				newCell = boss.instantiate()
				newCell.position = mapBP[i][j].pos
				call_deferred("add_child", newCell)
				
			addWalls(Vector2(i, j), newCell)
				
func addWalls(cellPos, newCell):
	var curCell = mapBP[cellPos.x][cellPos.y]
	if(curCell.type == null):
		return
		
	if(cellPos.x + 1 >= dimension or mapBP[cellPos.x + 1][cellPos.y].type == null):
		newCell.get_node("walls/east").set_layer_enabled(0, true)
		
	if(cellPos.x - 1 < 0  or mapBP[cellPos.x - 1][cellPos.y].type == null):
		newCell.get_node("walls/west").set_layer_enabled(0, true)
		
	if(cellPos.y + 1 >= dimension or mapBP[cellPos.x][cellPos.y + 1].type == null):
		newCell.get_node("walls/south").set_layer_enabled(0, true)
		
	if(cellPos.y - 1 < 0 or mapBP[cellPos.x][cellPos.y - 1].type == null):
		newCell.get_node("walls/north").set_layer_enabled(0, true)
	
