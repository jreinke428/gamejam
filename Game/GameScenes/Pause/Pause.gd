extends Control

func _process(_delta):
	if Input.is_action_just_released('esc') and !get_tree().paused:
		togglePause()

func togglePause():
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused

func _on_resume_pressed():
	await get_tree().create_timer(0.1).timeout
	togglePause()

func _on_evacuate_pressed():
	togglePause()
	get_tree().change_scene_to_file("res://Game/GameScenes/PlanetSelection/PlanetSelection.tscn")

func _on_quit_pressed():
	get_tree().quit()
