extends CharacterBody2D

enum BehaviorState {WALKING, ATTACKING, IDLE}

var waterMaterial = preload("res://Util/Shaders/WaterMaterial.tres")

@onready var animatedSprite = $AnimatedSprite2D
@onready var waterParticles = $WaterParticles
@onready var waterTrailingParticles = $WaterTrailingParticles
@onready var hitTimer = $HitTimer
@onready var attackCooldown = $AttackCooldown
@onready var world = $'../'

var attackTarget = null
var curBehavState: BehaviorState
var attacking = false

@export var speed = 30
@export var health = 5
@export var damage = 3
	
func _process(_delta):
	stateChanger()
	aM()
	waterParticleHandler()

func _physics_process(_delta):
	navigate()
	
func navigate():
	velocity = FlowField.getVector(global_position)*speed
	if world.isInWater(global_position): velocity /= 2
	move_and_slide()

func hit(damage):
	health -= damage
	modulate = '#ff9e9e'
	GlobalGameTools.createDamageNumber(global_position-Vector2(0,5), damage)
	hitTimer.start()
	if health <= 0: 
		GlobalGameTools.dropExperience(global_position, 10, world)
		queue_free()
	
func waterParticleHandler():
	if world.isInWater(global_position):
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
	
func stateChanger():
	if attackTarget and attackCooldown.is_stopped():
		curBehavState = BehaviorState.ATTACKING
	elif (abs(velocity.x) < 10 and abs(velocity.y) < 10):
		curBehavState = BehaviorState.IDLE
	else:
		curBehavState = BehaviorState.WALKING
		
func aM():
	if curBehavState == BehaviorState.IDLE:
		animatedSprite.play("idle")
	elif curBehavState == BehaviorState.WALKING:
		animatedSprite.play("walking")
		if velocity.x != 0:
			animatedSprite.scale.x=sign(velocity.x)
	elif curBehavState == BehaviorState.ATTACKING and attackCooldown.is_stopped():
		if animatedSprite.animation != "attacking":
			animatedSprite.play("attacking")
		
func _on_hit_timer_timeout():
	modulate = 'FFFFFF'

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Scanner"):
		attackTarget = body
		
func _on_attack_area_body_exited(body):
	if body == attackTarget: 
		attackTarget = null

func _on_animated_sprite_2d_animation_finished():
	if curBehavState == BehaviorState.ATTACKING:
		attackTarget.hit(damage)
		attackCooldown.start()
