extends Node2D

@onready var player := $World/Player
@onready var scanTimer: Timer = $ScanTimer
@onready var world: TileMap = $World
@onready var spawnTimer: Timer = $SpawnTimer

var scanInProgress := false
var scannerGlobalPosition: Vector2
var curEnemy = GlobalProperties.currentState.enemy.scene
var spawnParticles = preload('res://Util/Particles/SpawnParticles.tscn')
var scanCount = 0

var spawnTimerBuffer: float = 1.5
var totalSpawnTime: float
var secondsPerEnemy: float

var scanEventParams = [
	{
		"length": 20,
		"enemies": 5
	},
	{
		"length": 40,
		"enemies": 32
	},
	{
		"length": 60,
		"enemies": 46
	}
]

func _ready():
	Signals.start_scan_attempted.connect(startScan)
	Signals.scanner_destroyed.connect(scannerDestroyed)
	Signals.scan_over.connect(scanCompleted)
			
func startScan(scannerPosition: Vector2):
	if scanInProgress:
		return 
	
	scannerGlobalPosition = scannerPosition
	scanInProgress = true
		
	world.placeObject("scanner", world.local_to_map(scannerPosition))
	
	FlowField.setTarget(scannerGlobalPosition)
	Signals.scan_started.emit()
	
	scanTimer.start(scanEventParams[scanCount].length)
	await get_tree().create_timer(spawnTimerBuffer).timeout 
	totalSpawnTime = scanEventParams[scanCount].length - 2 * spawnTimerBuffer
	secondsPerEnemy = float(totalSpawnTime) / (float(scanEventParams[scanCount].enemies)-1)
	spawnEnemies(scannerGlobalPosition, 1)
	spawnTimer.start(secondsPerEnemy)

func scannerDestroyed():
	if scanInProgress: #robustness
		pass

func scanCompleted():
	scanCount += 1
	if scanCount == 3: Signals.level_complete.emit()

func spawnEnemies(scannerPosition, enemies):
	for i in range(enemies):
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
	scanTimer.stop()
	scanInProgress = false
	Signals.scan_over.emit()

func _on_spawn_timer_timeout():
	totalSpawnTime -= secondsPerEnemy
	spawnEnemies(scannerGlobalPosition, 1)
	
	if totalSpawnTime <= 0:
		spawnTimer.stop()
