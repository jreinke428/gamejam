extends CharacterBody2D

var speed = 100
var acceleration = 0.1
var friction = 0.4
var waterShader = preload("res://Util/Shaders/WaterShader.gdshader")

@onready var bodyAnimations = $BodyAnimation
@onready var armAnimations = $ArmAnimation
@onready var waterParticles = $WaterParticles
@onready var waterTrailingParticles = $WaterTrailingParticles

func _process(_delta):
	z_index = global_position.y as int
	animationManager()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	movement()
	
func movement():
	var direction = Vector2()
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	
	velocity = velocity.lerp(direction.normalized() * speed * (0.5 if GlobalGameTools.isInWater(global_position) else 1), acceleration) if direction.length() > 0 else velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
func animationManager():
	if GlobalGameTools.isInWater(global_position):
		bodyAnimations.material.shader = waterShader
		waterParticles.visible = true
		if abs(velocity.x) < 10 and abs(velocity.y) < 10:
			waterParticles.emitting = false
			waterTrailingParticles.emitting = false
		else:
			waterParticles.emitting = true
			waterTrailingParticles.emitting = true
	else:
		bodyAnimations.material.shader = null
		waterParticles.emitting = false
		waterTrailingParticles.emitting = false
		waterParticles.visible = false
		
	if abs(velocity.x) < 10 and abs(velocity.y) < 10:
		bodyAnimations.play("idle")
		armAnimations.play("idle")
	else:
		bodyAnimations.play("walking")
		armAnimations.play("walking")
		if velocity.x != 0:
			bodyAnimations.scale.x=sign(velocity.x)
			armAnimations.scale.x=sign(velocity.x)
		
