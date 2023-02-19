extends Node2D

@onready var player := $World/Player
@onready var scanTimer := $ScanTimer

var scanInProgress := false

func _ready():
	Signals.start_scan_attempted.connect(startScan)

func _process(delta):
	pass
	
func startScan():
	scanInProgress = true
	scanTimer.start()
	GlobalGameTools.spawnEnemies()



