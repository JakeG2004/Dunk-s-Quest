extends Sprite2D

@onready var HIT_EFFECT = preload("res://scenes/effects/lifesteal.tscn")

var SPEED = 1.5

var DAMAGE = 5
var KNOCKBACK = 1
var HEALING = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5).timeout
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.x += cos(rotation - 1.57) * SPEED
	position.y += sin(rotation - 1.57) * SPEED
	
func init(angle, newPosition):
	rotation = angle + 1.57
	position = newPosition
	
func _on_area_2d_body_entered(other):
	if(other.is_in_group("enemy")):
		other.hit(DAMAGE, KNOCKBACK)
		
		var tmpHit = HIT_EFFECT.instantiate()
		tmpHit.init(global_position)
		get_parent().call_deferred("add_child", tmpHit)
		queue_free()
