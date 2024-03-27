extends Node2D

@onready var ap = get_node("weaponAnim")
@onready var primaryWeapon = get_node("primaryWeapon")
@onready var secondaryWeapon = get_node("secondaryWeapon")

@onready var bolt = preload("res://scenes/objects/weapons/lifeBolt.tscn")

var DAMAGE = 1
var KNOCKBACK = 3
var ATTACK_RADIUS = 20

var bolts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
#lifesteal
func primary(angle):
	secondaryWeapon.hide()
	secondaryWeapon.scale = Vector2(1, 1)
	secondaryWeapon.get_node("Area2D/CollisionShape2D").disabled = true
	
	primaryWeapon.position = Vector2(cos(angle) * ATTACK_RADIUS, sin(angle) * ATTACK_RADIUS)
	primaryWeapon.rotation = angle + 1.57
	
	#FIX THIS PART
	var tmpBolt = bolt.instantiate()
	tmpBolt.init(angle, position)
	
	get_parent().get_parent().add_child(tmpBolt)
	
	ap.play("primary")
	
#AoE
func secondary(angle):
	ap.play("secondary")
	
func _on_area_2d_body_entered(other):
	if(other.is_in_group("enemy")):
		other.hit(DAMAGE, KNOCKBACK)
