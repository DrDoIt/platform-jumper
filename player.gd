extends CharacterBody2D

signal hit

var screen_size

var life = 0
const PUSH_FORCE = 100
const MAX_VELOCITY = 150
const SPEED = 300.0
const JUMP_VELOCITY = -500.0

#func _ready():
	#screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
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


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		hit.emit()
