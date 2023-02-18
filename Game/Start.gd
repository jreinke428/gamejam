extends Control

@onready var planets = [$Planets/Planet1, $Planets/Planet2, $Planets/Planet3, $Planets/Planet4, $Planets/Planet5]
@onready var planetTimer = $PlanetTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	movePlanets()

func movePlanets():
	if planetTimer.is_stopped():
		var planet = planets[randi_range(0,4)]
		var tween = planet.create_tween()
		planet.global_position.y = randf_range(0,160)
		var time = randf_range(5, 10)
		tween.tween_property(planet, 'position:x', 320 if planet.global_position.x < 0 else -40, time)
		planetTimer.start(time+randf_range(1,3))
