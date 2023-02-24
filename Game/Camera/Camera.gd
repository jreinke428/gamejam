extends Camera2D

var newZoom
var tween

func _unhandled_input(event):
	if event.is_action('zoom_in') and zoom.x < 2: newZoom = (zoom.x+0.5 if zoom.x >= 1 else zoom.x*1.2)
	elif event.is_action('zoom_out') and zoom.x > 0.5: newZoom = (zoom.x-0.5 if zoom.x > 1 else zoom.x/1.2)
	else: return
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, 'zoom', Vector2(newZoom, newZoom), 0.1)
