extends Control

var planetSelections = []

@onready var buttons := $ButtonContainer.get_children()

func _ready():
	var planetValues = GlobalProperties.PLANETS.duplicate(true)
	planetValues.shuffle()
	var plants = GlobalProperties.PLANTS.duplicate(true)
	plants.shuffle()
	var enemies = GlobalProperties.ENEMIES.duplicate(true)
	enemies.shuffle()
	for i in range(3):
		var selection = {
			'planet' : planetValues.pop_front(),
			'plant' : plants.pop_front(),
			'enemy' : enemies.pop_front()
		}
		planetSelections.append(selection)
		
		buttons[i].icon = selection.planet.texture

func _on_planet_button_1_pressed():
	GlobalProperties.currentState.planet = planetSelections[0].planet
	GlobalProperties.currentState.plant = planetSelections[0].plant
	GlobalProperties.currentState.enemy = planetSelections[0].enemy

func _on_planet_button_2_pressed():
	GlobalProperties.currentState.planet = planetSelections[1].planet
	GlobalProperties.currentState.plant = planetSelections[1].plant
	GlobalProperties.currentState.enemy = planetSelections[1].enemy

func _on_planet_button_3_pressed():
	GlobalProperties.currentState.planet = planetSelections[2].planet
	GlobalProperties.currentState.plant = planetSelections[2].plant
	GlobalProperties.currentState.enemy = planetSelections[2].enemy
