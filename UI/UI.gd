extends Control

var healthBarWidth = 56.0
@onready var healthBar = $HealthBar/Health
@onready var healthText = $HealthBar/HealthText
@onready var plantTexture = $PlantContainer/PlantBox/PlantTexture
@onready var plantText = $PlantContainer/PlantText
@onready var player = $/root/Test/World/Player
var scansCompleted = -1

func _ready():
	initialize()
	connectSignals()

func initialize():
	changeHealth(player.health, player.maxHealth)
	plantTexture.texture = GlobalProperties.currentState.plant.texture
	scanCompleted()
	
func connectSignals():
	Signals.player_health_changed.connect(changeHealth)
	Signals.scan_over.connect(scanCompleted)
	
func changeHealth(newHealth, maxHealth):
	healthText.text = '{0}/{1}'.format([newHealth, maxHealth])
	healthBar.create_tween().tween_property(healthBar, 'size:x', clampf(healthBarWidth*newHealth/maxHealth,0.0,healthBarWidth), 0.1)
	
func scanCompleted():
	scansCompleted += 1
	plantText.text = '{0}/3'.format([scansCompleted])
