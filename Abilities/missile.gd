extends RigidBody2D

@export var speed = 400
@export var direction:int
var velocity:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	if direction <=0:
		$AnimatedSprite2D.flip_v = true
		#$AnimatedSprite2D.rotate(deg_to_rad(-250))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = speed * direction
	
	global_position += Vector2(velocity*delta,0)
	await get_tree().create_timer(5).timeout
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		await get_tree().create_timer(.01).timeout
		queue_free()
