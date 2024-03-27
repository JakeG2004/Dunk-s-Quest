extends Node2D

@onready var ap = get_node("weaponAnim")
@onready var primaryWeapon = get_node("primaryWeapon")
@onready var secondaryWeapon = get_node("secondaryWeapon")

var DAMAGE = 5
var KNOCKBACK = 3

var ATTACK_RADIUS = 20

var shieldOut = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func primary(angle):
	primaryWeapon.position = Vector2(cos(angle) * ATTACK_RADIUS, sin(angle) * ATTACK_RADIUS)
	primaryWeapon.rotation = angle + 1.57
	
	ap.play("knight_primary")
	
func secondary(angle):
	shieldOut = !shieldOut
	
	if(shieldOut):
		ap.play("knight_secondary")
		
		secondaryWeapon.position = Vector2(cos(angle) * ATTACK_RADIUS, sin(angle) * ATTACK_RADIUS)
		secondaryWeapon.rotation = angle
		
	else:
		ap.play_backwards("knight_secondary")

func _on_area_2d_body_entered(other):
	if(other.is_in_group("enemy")):
		other.hit(DAMAGE, KNOCKBACK)
