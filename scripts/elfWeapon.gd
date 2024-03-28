extends Node2D

@onready var ap = get_node("weaponAnim")
@onready var primaryWeapon = get_node("primaryWeapon")
@onready var secondaryWeapon = get_node("secondaryWeapon")

@onready var arrow = preload("res://scenes/objects/weapons/Arrow.tscn")

var DAMAGE = 3
var KNOCKBACK = 1
var TP_RADIUS = 40

@export var COOLDOWNTIME = .25

var coolDown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
#lifesteal
func primary(angle):
	if(coolDown):
		return
	
	coolDown = true
	
	var tmpArrow = arrow.instantiate()
	tmpArrow.init(angle, get_parent().position)
	
	get_parent().get_parent().add_child(tmpArrow)
	
	await get_tree().create_timer(COOLDOWNTIME).timeout
	coolDown = false
	
#AoE
func secondary(angle):
	print(global_position)
	get_parent().position += Vector2(cos(angle) * TP_RADIUS, sin(angle) * TP_RADIUS)
	print(global_position)
	
func _on_area_2d_body_entered(other):
	if(other.is_in_group("enemy")):
		other.hit(DAMAGE, KNOCKBACK)
