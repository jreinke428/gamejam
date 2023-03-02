extends Area2D

var speed: int = 200
var damage: int = 1

var pierceCount = GlobalProperties.playerStats.pierce

func _physics_process(delta):
	var movement = Vector2.RIGHT.rotated(rotation) * speed * delta
	global_position += movement
	
func initializeBullet(sspeed: int, ddamage: int):
	self.speed = sspeed
	self.damage = ddamage
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_area_entered(area):
	if area.get_parent().is_in_group("Enemy") and pierceCount > 0:
		pierceCount-=1
		area.get_parent().hit(damage)
		if pierceCount == 0: queue_free()
