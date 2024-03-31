extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func isTile(newPos):
	var tilePos = local_to_map(newPos)
	var tileData = get_cell_tile_data(0, tilePos)
	
	print(tilePos)
	
	if tileData:
		return true
		
	return false
