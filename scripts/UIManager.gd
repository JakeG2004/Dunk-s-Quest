extends Control

@onready var charManager = get_parent().get_node("characterManager")
@onready var healthBar = get_node("CanvasLayer/TextureProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	healthBar.value = charManager.HEALTH
