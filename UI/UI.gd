extends Control

var healthBarWidth = 56.0
@onready var healthBar = $HealthBar/Health
@onready var healthText = $HealthBar/HealthText
@onready var player = $/root/Test/World/Player
var playerHealth

func _ready():
	playerHealth = player.health
	changeHealth(playerHealth, player.maxHealth)
	
func _process(_delta):
	if Input.is_action_just_released("guns_one"): player.health -= 3
	if playerHealth != player.health: changeHealth(player.health, player.maxHealth)
	
func changeHealth(newHealth, maxHealth):
	healthText.text = '{0}/{1}'.format([newHealth, maxHealth])
	healthBar.create_tween().tween_property(healthBar, 'size:x', clampf(healthBarWidth*newHealth/maxHealth,0.0,healthBarWidth), 0.1)
