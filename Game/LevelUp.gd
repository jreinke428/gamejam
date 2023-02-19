extends Control

func _ready():
	Signals.level_up.connect(initialize)
	
func initialize():
	get_tree().paused = true
	visible = true

func uninitialize():
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	visible = false
	
func _on_damage_button_pressed():
	GlobalProperties.playerStats.damage *= 2
	uninitialize()

func _on_fire_rate_button_pressed():
	GlobalProperties.playerStats.fireRate /= 1.5
	uninitialize()

func _on_pierce_button_pressed():
	GlobalProperties.playerStats.pierce += 1
	uninitialize()
