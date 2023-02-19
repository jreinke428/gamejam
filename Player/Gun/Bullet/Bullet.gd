extends Area2D

var speed: int = 200
var damage: int = 1

func _physics_process(delta):
	var movement = Vector2.RIGHT.rotated(rotation) * speed * delta
	global_position += movement
	
func initializeBullet(speed: int, damage: int):
	speed = speed
	damage = damage
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().hit(damage)
		queue_free()
