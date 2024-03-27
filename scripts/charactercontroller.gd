extends CharacterBody2D

var SPEED = 90
var ATTACK_RADIUS = 20
var ATTACK_DAMAGE = 5

var curCharacter = "knight"
var characterVariant = "male"

@onready var playerAnim = get_node("playerAnim")
@onready var charSprite = get_node("charSprite")

@onready var weaponController = get_node("weaponController")

func _ready():
	charSprite.flip_h = false

func _physics_process(_delta):
	#Update horizontal velocity
	var horiz = Input.get_axis("left", "right")
	if horiz:
		velocity.x = horiz * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Update vertical velocity
	var vert = Input.get_axis("up", "down")
	if vert:
		velocity.y = vert * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	#Handle attacks
	if(Input.is_action_just_pressed("left_click")):
		primaryAttack()
		
	if(Input.is_action_just_pressed("right_click")):
		secondaryAttack()
		
	#Function calls
	move_and_slide()
	update_sprite(horiz)
	update_anims(vert, horiz)

func primaryAttack():
	var mouse = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse)
	
	weaponController.primary(angle)

func secondaryAttack():
	var mouse = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse)

	weaponController.secondary(angle)
	
#Update flipping of sprite
func update_sprite(horiz):
	if(horiz > 0):
		charSprite.flip_h = false
	elif(horiz < 0):
		charSprite.flip_h = true

#Update animations
func update_anims(vert, horiz):
	if(Vector2(vert, horiz) != Vector2(0, 0)):
		playerAnim.play("player_run")
	else:
		playerAnim.play("player_idle")

func damage(inDamage):
	print("Damaged ", inDamage)

func _on_body_entered(other):
	if(other.is_in_group("enemy")):
		damage(other.DAMAGE)
	if(other.is_in_group("heal")):
		print("heal")
		
func init(newPos):
	print(newPos)
	velocity = newPos
	move_and_slide()
