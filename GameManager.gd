extends Node2D

@onready var player := $World/Player
@onready var scanTimer := $ScanTimer
@onready var world := $World

var scanInProgress := false
var scannerGlobalPosition: Vector2
var curEnemy = GlobalProperties.currentState.enemy.scene
var spawnParticles = preload('res://Util/Particles/SpawnParticles.tscn')

func _ready():
	Signals.start_scan_attempted.connect(startScan)

func _process(delta):
	if not scanTimer.is_stopped():
		spawnEnemies(scannerGlobalPosition)
	
func startScan(scannerPosition: Vector2):
	if scanInProgress:
		return 
	
	scannerGlobalPosition = scannerPosition
	scanInProgress = true
	
	FlowField.setTarget(scannerGlobalPosition)
	Signals.scan_started.emit()
	scanTimer.start()

func spawnEnemies(scannerPosition):
	if randf() < 0.05:
		var dist = randf_range(100,150)
		var angle = randf_range(0,360)
		var coords = Vector2(cos(angle)*dist, sin(angle)*dist)
		while(!world.isValidSpawn(scannerPosition+coords)):
			dist = randf_range(100,150)
			angle = randf_range(0,360)
			coords = Vector2(cos(angle)*dist, sin(angle)*dist)
		spawnEnemy(scannerPosition+coords)

func spawnEnemy(pos):
	var particles : GPUParticles2D = spawnParticles.instantiate()
	particles.global_position = pos
	particles.emitting = true
	world.add_child(particles)
	await get_tree().create_timer(1.0).timeout 
	var enemy = curEnemy.instantiate()
	enemy.global_position = pos
	world.add_child(enemy)
	enemy.create_tween().tween_property(enemy, 'scale', Vector2(1, 1), 0.3).from(Vector2(0.1,0.1))

func _on_scan_timer_timeout():
	print("Scan done.")
	scanInProgress = false
	Signals.scan_over.emit()
