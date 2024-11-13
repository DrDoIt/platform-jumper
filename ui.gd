extends Node

#var screenSize= DisplayServer.window_get_size()
var padding = 20

@onready var player: CharacterBody2D = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lifeCounter = player.life
	$GridContainer/Lives.text = str("Lives Used: ", lifeCounter)
	
	var xpCounter = Stats.player_xp
	$GridContainer/XP.text = str("xp: ", xpCounter)
	
