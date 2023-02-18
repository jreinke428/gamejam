extends Node

func isInWater(pos):
	return false
	
func toggleVisibility(item: CanvasItem):
	if item.visible:
		item.hide()
	else:
		item.show()
