extends Sprite2D

@export var bullet: PackedScene = null
@onready var fireRateTimer = $FireRate

func _ready():
	fireRateTimer.wait_time = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tryShootGun():
	if fireRateTimer.is_stopped():
		var newBullet: Area2D = bullet.instantiate()
		get_tree().current_scene.add_child(newBullet)
		newBullet.global_position = global_position + global_position.direction_to(get_global_mouse_position()) * 11
		newBullet.global_rotation = global_rotation
		
		fireRateTimer.start()
