extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/Enemy.texture = GlobalProperties.currentState.enemy.texture
	$VBoxContainer/HBoxContainer/Plant.texture = GlobalProperties.currentState.plant.texture
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Test.tscn")

