extends Node

signal life()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newGame() -> void:
	$Player.respawn($Marker2D.position)
	life.emit()


func _on_lava_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		newGame()
