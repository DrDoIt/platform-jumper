extends Node



signal life()
#var songs = ["Intro","Song2"]
#var nextSong = ""
#var songNum=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newGame() -> void:
	$Player.respawn($Marker2D.position)
	life.emit()


func _on_lava_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		newGame()


func _on_player_hit() -> void:
	newGame()



func _on_soundtrack_finished() -> void:
	$Audio/Intro.play()
	#songNum+=1
