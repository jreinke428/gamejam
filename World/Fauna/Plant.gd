extends Area2D

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
			Signals.start_scan_attempted.emit(global_position)
			
func _on_scan_over():
	canStartScan = true
	
func _on_scan_started():
	canStartScan = false

func _on_body_entered(body):
	if body.is_in_group("Player") and canStartScan:
		playerNearby = true
		print("Press E To Begin Scan") # replace with UI for start scan

func _on_body_exited(body):
	if body.is_in_group("Player"):
		playerNearby = false
