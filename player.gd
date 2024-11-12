extends CharacterBody2D

signal hit

var screen_size

const PUSH_FORCE = 100
const MAX_VELOCITY = 150
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var life = 0
var attacking = false
var facing: String

@onready var despawn: Timer = $Despawn
#func _ready():
	#screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var state = "rest"
	# Add the gravity.
	var gravity = get_gravity() * delta
	if not is_on_floor():
		velocity += gravity

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
		if direction >0:
			facing = "right"
			$Direction.position.x = 30
		if direction <=0:
			facing = "left"
			$Direction.position.x = 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Handle Attack
	if Input.is_action_just_pressed("UseSpell"):
		if attacking == false:
			attacking = true
			$AttackCooldown.start()
			var MAGIC_MISSILE = preload("res://Abilities/magic_missle.tscn")
			var missile = MAGIC_MISSILE.instantiate()
			print(facing)
			if facing == "right":
				missile.direction = 1
				print(missile.direction)
			if facing == "left":
				missile.direction = -1
				print(missile.direction)
			missile.position = $Direction.global_position
			get_parent().add_child(missile)

		
	
	# Animation
	$AnimatedSprite2D.play()
	if velocity == Vector2(0,0):
		state = "rest"
		$AnimatedSprite2D.animation = "idle"
	
	if velocity.y != 0:
		if velocity.y >=0:
			$AnimatedSprite2D.animation = "fall"
		else:
			$AnimatedSprite2D.animation = "jump"
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		if collision_box.is_in_group("Enemies"):
			if collision_box.is_in_group("Hurtboxes"):
				pass
			else:
				hit.emit()
		if collision_box.is_in_group("Boxes") and abs(collision_box.get_linear_velocity().x) < MAX_VELOCITY:
			collision_box.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
			
	move_and_slide()
	
	
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") && is_on_floor()):
		position.y += 1
	#position = position.clamp(Vector2.ZERO, screen_size)
	
func respawn(pos):
	position = pos
	


func _on_main_life() -> void:
	life += 1


func _on_attack_cooldown_timeout() -> void:
	attacking = false
