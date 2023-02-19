extends StaticBody2D

@onready var scanAnimationRateTimer: Timer = $ScanAnimationRate
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var health := 50

func _ready():
	Signals.scan_over.connect(scanOver)

func _process(delta):
	tryPlayingScanAnimation()
	
func hit(damage):
	health -= damage
	if health <= 0:
		Signals.scanner_destroyed.emit()
		queue_free()
		
func scanOver():
	print("Scan complete, returning to player.")
	queue_free()

func tryPlayingScanAnimation():
	if !scanAnimationRateTimer.is_stopped():
		return
		
	animatedSprite.play("scanning")
	scanAnimationRateTimer.start()
	
	
