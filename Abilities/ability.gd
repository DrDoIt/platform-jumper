class_name Ability
extends Resource

# Tries to use ability and returns with success bool
func use(p_user : Node2D) -> bool:
	push_error("Virtual function - implement in child class")
	return false
