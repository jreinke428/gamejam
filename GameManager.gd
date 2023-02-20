extends Node2D

@onready var player := $World/Player
@onready var scanTimer: Timer = $ScanTimer
@onready var world: TileMap = $World

var scanInProgress := false
var scannerGlobalPosition: Vector2
var curEnemy = GlobalProperties.currentState.enemy.scene
var spawnParticles = preload('res://Util/Particles/SpawnParticles.tscn')
var scanCount = 0

var enemySpawnsRemaining: int
var scanSecondsRemaining: int # for the ScanTimer

var scanEventParams = [
	{
		"length": 21,
		"enemiesPerSecond": 1
	},
	{
		"length": 41,
		"enemiesPerSecond": 2
	},
	{
		"length": 61,
		"enemiesPerSecond": 2
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
	
	enemySpawnsRemaining = scanEventParams[scanCount].enemiesPerSecond
	scanSecondsRemaining = scanEventParams[scanCount].length
	
	world.placeObject("scanner", world.local_to_map(scannerPosition))
	
	FlowField.setTarget(scannerGlobalPosition)
	Signals.scan_started.emit()
	scanTimer.start()
	
func scannerDestroyed():
	if scanInProgress: #robustness
		pass

func scanCompleted():
	scanCount += 1
	if scanCount == 3: Signals.level_complete.emit()

func spawnEnemies(scannerPosition):
	for i in range(scanEventParams[scanCount].enemiesPerSecond):
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

func calcHowManyEnemiesToSpawn(enemiesLeftToSpawn: int, timeRemaining: int) -> int:
	return int(round(enemiesLeftToSpawn / timeRemaining))

func _on_scan_timer_timeout():
	scanSecondsRemaining -= 1
	spawnEnemies(scannerGlobalPosition)
	if scanSecondsRemaining == 0:
		scanTimer.stop()
		scanInProgress = false
		Signals.scan_over.emit()
