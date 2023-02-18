extends Area2D

const RIGHT = Vector2.RIGHT
@export var SPEED: int = 200

func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
