extends StaticBody2D

@onready var scanAnimationRateTimer: Timer = $ScanAnimationRate
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var scanSound: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var damagedSound: AudioStreamPlayer2D = $AudioStreamPlayer2
@onready var healthBar = $Health/HealthBar

var health := 50
var maxHealth := 50
var healthBarWidth := 12

func _ready():
	Signals.scan_over.connect(scanOver)

func _process(delta):
	tryPlayingScanAnimation()
	
func hit(damage):
	health -= damage
	damagedSound.play()
	changeHealth()
	GlobalGameTools.createDamageNumber(global_position-Vector2(0,5), damage, 'ffffff')
	if health <= 0:
		Signals.scanner_destroyed.emit()
		queue_free()
		
func scanOver():
	queue_free()

func tryPlayingScanAnimation():
	if !scanAnimationRateTimer.is_stopped():
		return
		
	animatedSprite.play("scanning")
	scanSound.play()
	scanAnimationRateTimer.start()
	
func changeHealth():
	healthBar.create_tween().tween_property(healthBar, 'size:x', clampf(healthBarWidth*health/maxHealth,0.0,healthBarWidth), 0.1)
	
	
