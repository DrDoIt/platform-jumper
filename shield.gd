extends Area2D
var player = null
var fizzleTime = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player =  get_parent().get_node("Player")
	$CPUParticles2D.emitting = false
	$Fizzle.wait_time = fizzleTime
	$Fizzle.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play()
	$AnimatedSprite2D2.play()
	if player.shield_pos:
		position = player.shield_pos


func _on_fizzle_timeout() -> void:
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D2.hide()
	$CPUParticles2D.emitting = true
