extends Node



signal life()

enum { START, CHECKPOINT1, CHECKPOINT2}
var spawnPoint = START

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newGame() -> void:
	match spawnPoint:
		START:
			$Player.respawn($Marker2D.position)
		CHECKPOINT1:
			$Player.respawn($Checkpoint1.position)
	life.emit()


func _on_lava_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and $Player.shielded == false:
		newGame()


func _on_player_hit() -> void:
	newGame()


func _on_soundtrack_finished() -> void:
	$Audio/Intro.play()
	#songNum+=1


func _on_checkpoint_checkpoint_achieved(delta) -> void:
	Stats.player_mana = move_toward(Stats.player_mana,1000,1000)


func _on_checkpoint_checkp() -> void:
	spawnPoint = CHECKPOINT1
