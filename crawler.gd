extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("AttackSpell"):
		queue_free()
		# Reward
		Stats.player_mana += 100


func _on_weak_spot_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		# Reward
		Stats.player_mana += 100
