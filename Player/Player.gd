extends CharacterBody2D

var speed = 100
var acceleration = 0.1
var friction = 0.4
var aimingGun = false
var canStartScan = false
var waterShader = preload("res://Util/Shaders/WaterShader.gdshader")

@onready var bodyAnimations = $BodyAnimation
@onready var armAnimations = $ArmAnimation
@onready var waterParticles = $WaterParticles
@onready var waterTrailingParticles = $WaterTrailingParticles
@onready var gun = $Gun

func _process(_delta):
	animationManager()
	gunManager()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	movement()
	
func gunManager():
	if Input.is_action_pressed("left_click"):
		shootGun()
	if Input.is_action_just_released("left_click"):
		endShootGun()
		
func shootGun():
	if gun.visible:
		aimGun()
		gun.tryShootGun()
	else:
		GlobalGameTools.toggleVisibility(armAnimations)
		GlobalGameTools.toggleVisibility(gun)
		aimGun()
		gun.tryShootGun()
		
func aimGun():
	var mPos = get_global_mouse_position()
	gun.look_at(mPos)
	if mPos.x < global_position.x:
		bodyAnimations.scale.x = -1
		armAnimations.scale.x = -1
		gun.scale.y = -1
	else:
		bodyAnimations.scale.x = 1
		armAnimations.scale.x = 1
		gun.scale.y = 1

func endShootGun():
	GlobalGameTools.toggleVisibility(armAnimations)
	GlobalGameTools.toggleVisibility(gun)
	
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
		material.shader = waterShader
		waterParticles.visible = true
		if abs(velocity.x) < 10 and abs(velocity.y) < 10:
			waterParticles.emitting = false
			waterTrailingParticles.emitting = false
		else:
			waterParticles.emitting = true
			waterTrailingParticles.emitting = true
	else:
		material.shader = null
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
			bodyAnimations.scale.x = sign(velocity.x)
			armAnimations.scale.x = sign(velocity.x)
		
