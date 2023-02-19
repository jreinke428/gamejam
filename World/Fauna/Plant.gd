extends Area2D

@onready var scanText = $ScanText

var canStartScan := true
var playerNearby := false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.scan_over.connect(_on_scan_over)
	Signals.scan_started.connect(_on_scan_started)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canStartScan and playerNearby: 
		if Input.is_action_just_pressed("start_scan"):
			monitoring = false
			Signals.start_scan_attempted.emit(global_position)
			
func _on_scan_over():
	canStartScan = true
	
func _on_scan_started():
	canStartScan = false
	scanText.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player") and canStartScan:
		playerNearby = true
		scanText.visible = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		playerNearby = false
		scanText.visible = false
