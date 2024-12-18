extends Node

#var screenSize= DisplayServer.window_get_size()


@onready var bar: ProgressBar = $GridContainer/ProgressBar
@onready var player: CharacterBody2D = $"../../Player"
@onready var spellSlot1 = $GridContainer2/CenterContainer/ColorRect
@onready var spellSlot2 = $GridContainer2/CenterContainer2/ColorRect2
@onready var spellSlot3 = $GridContainer2/CenterContainer3/ColorRect3

var higlightedColor = 50
var padding = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lifeCounter = player.life
	$GridContainer/Lives.text = str("Lives Used: ", lifeCounter)
	
	var manaCounter = Stats.player_mana
	bar.value = manaCounter
	
	
	
	if player.selectedSpell == player.MISSILE:
		highlight(spellSlot1)
		darken(spellSlot2,spellSlot3)
	elif player.selectedSpell == player.SHIELD:
		highlight(spellSlot2)
		darken(spellSlot1,spellSlot3)
	elif player.selectedSpell == player.BOOST:
		highlight(spellSlot3)
		darken(spellSlot1,spellSlot2)
	# TODO Fix UI colors
func highlight(cell):
	cell.color = 50
	
func darken(cell1,cell2):
	cell1.color = 100
	cell2.color = 100
