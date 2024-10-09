class_name ProjectileLaunchAbility
extends Ability

@export var projectile_scene : PackedScene
@export var instancing_offset : Vector2

func use(p_user : Node2D) -> bool:
	var instance : Projectile = projectile_scene.instantiate()
	p_user.get_parent().add_child(instance)
	
	var instance_position = p_user.global_position + instancing_offset
	instance.global_position = instance_position
	
	
	
	
	return true
