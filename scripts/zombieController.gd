extends CharacterBody2D

@onready var ap = get_node("AnimationPlayer")
@onready var sprite = get_node("Zombie")
@onready var players = get_tree().get_nodes_in_group("player")
@onready var healthBar = get_node("TextureProgressBar")

var player

var target = null

var MAX_HEALTH = 10
var HEALTH = MAX_HEALTH

@export var DAMAGE = 5
@export var MAX_SPEED = 50  # Adjust this value as needed
@export var ACCELERATION = 500  # Adjust this value as needed

var DETECT_RADIUS = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	player = players[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	players = get_tree().get_nodes_in_group("player")
	player = players[0]
	
	if target != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
	if position.distance_to(player.global_position) <= DETECT_RADIUS:
		target = player

	move_and_slide()
	update_sprite()
	update_anims()

func update_anims():
	if velocity.length() >= 0.3:
		ap.play("run")
	else:
		ap.play("idle")

func update_sprite():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func hit(inDamage, knockback):
	HEALTH -= inDamage
	
	healthBar.show()
	healthBar.value = HEALTH * 100 / MAX_HEALTH
	
	velocity *= -knockback
	var oldMod = sprite.modulate
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	
	if(HEALTH <= 0):
		queue_free()
		
	sprite.modulate = oldMod
	
