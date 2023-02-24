extends Area2D

var MAX_SPEED = 100
var ACCELERATION = 50
var FLOAT_AMPLITUDE = 0.05
var FLOAT_SPEED = 3

var player = null
var velocity = Vector2.ZERO
var isBeingPickedUp = false
var tween
	
func _physics_process(delta):
	if isBeingPickedUp:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 13:
			player.pickupExperience(1)
			queue_free()
			
		global_position += velocity
	else:
		spriteFloat()
			
func spriteFloat():
	var y_offset = sin(Time.get_unix_time_from_system() * FLOAT_SPEED) * FLOAT_AMPLITUDE
	position.y += y_offset
	
func goToPlayer(body):
	tween.kill()
	player = body
	isBeingPickedUp = true
