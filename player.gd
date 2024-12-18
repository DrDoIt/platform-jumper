extends CharacterBody2D

signal hit

var screen_size

const PUSH_FORCE = 100
const MAX_VELOCITY = 150
@export var jump_velocity = -500.0

# Speed and Dash
var speed  = 300.0
var dashing = false

# Player Life
var life = 0

# Diraction and Attacking
var facing: String
var attacking = false

# Shielding
var shielded = false
var shield = null
var shield_pos: Vector2

# Boost
var boosted = false
var charging = false
var landed = true

enum { MISSILE, SHIELD, BOOST }
var selectedSpell = MISSILE


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var state = "rest"

	# Add the gravity.
	var gravity = get_gravity() * delta
	if not is_on_floor():
		velocity += gravity
	if is_on_floor():
		landed = true


	# Handle jump.
	if Input.is_action_pressed("Run") and is_on_floor():
		speed = 500
		dashing = true
	if Input.is_action_just_released("Run"):
		speed = 300
		dashing = false
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if dashing:
			velocity.y = jump_velocity * 1.2
		else:
			velocity.y = jump_velocity
		print(velocity.y)
	if boosted:
		velocity.y = jump_velocity


	# Handle movement
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * speed
		if direction >0:
			facing = "right"
			$Direction.position.x = 30
		if direction <=0:
			facing = "left"
			$Direction.position.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


	# Handle spell selection
	if Input.is_action_just_pressed("SpellSlot1"):
		selectedSpell = MISSILE
	if Input.is_action_just_pressed("SpellSlot2"):
		selectedSpell = SHIELD
	if Input.is_action_just_pressed("SpellSlot3"):
		selectedSpell = BOOST


	# Handle spells
	if Input.is_action_just_pressed("UseSpell"):
		if Stats.player_mana >0:
			match selectedSpell:
				MISSILE:
					if attacking == false:
						attacking = true
						$AttackCooldown.start()
						var MAGIC_MISSILE = preload("res://Abilities/magic_missle.tscn")
						var missile = MAGIC_MISSILE.instantiate()
						print(facing)
						if facing == "left":
							missile.direction = -1
							print(missile.direction)
						else:
							missile.direction = 1
							print(missile.direction)
						missile.position = $Direction.global_position
						get_parent().add_child(missile)
						Stats.player_mana -= 50
				SHIELD:
					if !shielded:
						shielded = true
						$ShieldCooldown.start()
						const SHIELD_SCENE = preload("res://Abilities/shield.tscn")
						shield = SHIELD_SCENE.instantiate()
						shield.position = global_position
						get_parent().add_child(shield)
						Stats.player_mana -= 50
				BOOST:
					if !boosted:
						$Boost.start()
						boosted = true
						Stats.player_mana -= 50
						$BoostParts.emitting = true
						landed = false
						
		else:
			print("no mana")

	# Charging
	if charging:
		if Stats.player_mana <1000:
			Stats.player_mana = move_toward(Stats.player_mana,1000,20)
		else:
			charging = false


	# Animations
	$AnimatedSprite2D.play()
	if velocity == Vector2(0,0):
		state = "rest"
		$AnimatedSprite2D.animation = "idle"
		shield_pos = position
	if velocity.y != 0:
		if velocity.y >=0:
			if not is_on_floor():
				$AnimatedSprite2D.animation = "boost_fall"
			else:
				$AnimatedSprite2D.animation = "fall"
			shield_pos = position - Vector2(0,1)
		else:
			if not is_on_floor():
				$AnimatedSprite2D.animation = "boost"
			else:
				$AnimatedSprite2D.animation = "jump"
			shield_pos = position - Vector2(0,1)
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		if velocity.x > 0:
			shield_pos = position + Vector2(30,0)
		if velocity.x < 0:
			shield_pos = position - Vector2(0,0)
	if !landed and velocity.y>0:
		$FallingLines.emitting = true
	else:
		$FallingLines.emitting = false


	# Collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		if collision_box:
			if collision_box.is_in_group("Enemies"):
				if collision_box.is_in_group("Hurtboxes"):
					pass
				else:
					if !shielded:
						hit.emit()
			if collision_box.is_in_group("Boxes") and abs(collision_box.get_linear_velocity().x) < MAX_VELOCITY:
				collision_box.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
	move_and_slide()


func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down") && is_on_floor()):
		position.y += 1


func respawn(pos):
	position = pos


func _on_main_life() -> void:
	life += 1


# Timers
func _on_attack_cooldown_timeout() -> void:
	attacking = false


func _on_shield_cooldown_timeout() -> void:
	shielded = false
	shield.queue_free()


func _on_boost_timeout() -> void:
	boosted = false
	$BoostParts.emitting = false


func _on_checkpoint_checkp() -> void:
	charging = true
