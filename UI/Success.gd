extends Control

func _ready():
	Signals.level_complete.connect(initialize)

func initialize():
	get_tree().paused = true
	visible = true

func _on_evacuate_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/PlanetSelection.tscn")

func _on_quit_pressed():
	get_tree().quit()
