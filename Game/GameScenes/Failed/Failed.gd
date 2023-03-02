extends Control

func _ready():
	Signals.player_death.connect(initialize)
	Signals.scanner_destroyed.connect(initialize)

func initialize():
	get_tree().paused = true
	visible = true

func _on_evacuate_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/GameScenes/PlanetSelection/PlanetSelection.tscn")

func _on_quit_pressed():
	get_tree().quit()
