extends Node
	
func toggleVisibility(item: CanvasItem):
	if item.visible:
		item.hide()
	else:
		item.show()
		
		
