extends Node2D

@onready var player := $World/Player
@onready var scanTimer := $ScanTimer

var scanInProgress := false
var scannerGlobalPosition: Vector2

func _ready():
	Signals.start_scan_attempted.connect(startScan)

func _process(delta):
	if not scanTimer.is_stopped():
		GlobalGameTools.spawnEnemies(scannerGlobalPosition)
	
func startScan(scannerPosition: Vector2):
	if scanInProgress:
		return 
	
	scannerGlobalPosition = scannerPosition
	scanInProgress = true
	
	FlowField.setTarget(scannerGlobalPosition)
	Signals.scan_started.emit()
	scanTimer.start()

func _on_scan_timer_timeout():
	print("Scan done.")
	Signals.scan_over.emit()
