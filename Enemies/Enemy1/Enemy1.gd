extends CharacterBody2D

var waterMaterial = preload("res://Util/Shaders/WaterMaterial.tres")

@onready var animatedSprite = $AnimatedSprite2D
@onready var waterParticles = $WaterParticles
@onready var waterTrailingParticles = $WaterTrailingParticles
var speed = 30
var health = 50
	
func _process(_delta):
	animationManager()

func _physics_process(_delta):
	navigate()
	
func navigate():
	velocity = FlowField.getVector(global_position)*speed
	if GlobalGameTools.isInWater(global_position): velocity /= 2
	move_and_slide()

func hit(damage):
	health -= damage
	modulate = '#ff9e9e'
	#hitTimer.start(0.2)
	if health <= 0: queue_free()
	
func animationManager():
	if GlobalGameTools.isInWater(global_position):
		material = waterMaterial
		waterParticles.visible = true
		if abs(velocity.x) < 10 and abs(velocity.y) < 10:
			waterParticles.emitting = false
			waterTrailingParticles.emitting = false
		else:
			waterParticles.emitting = true
			waterTrailingParticles.emitting = true
	else:
		material = null
		waterParticles.emitting = false
		waterTrailingParticles.emitting = false
		waterParticles.visible = false
	if (abs(velocity.x) < 10 and abs(velocity.y) < 10):
		animatedSprite.play("idle")
	else:
		animatedSprite.play("walking")
		if velocity.x != 0:
			animatedSprite.scale.x=sign(velocity.x)

