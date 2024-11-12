extends RigidBody2D

@export var speed = 200
@export var direction:int
var velocity:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play()
	if direction <=0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.rotate(deg_to_rad(-250))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = speed * direction
	
	global_position += Vector2(velocity*delta,0)
	await get_tree().create_timer(5).timeout
	queue_free()
