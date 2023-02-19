extends Area2D

var canStartScan := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canStartScan:
		if Input.is_action_just_pressed("start_scan"):
			Signals.start_scan_attempted.emit()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		canStartScan = true
		print("Press E To Begin Scan")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		canStartScan = false
