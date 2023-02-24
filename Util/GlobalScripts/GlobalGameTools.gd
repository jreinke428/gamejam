extends Node

var damageNumber = preload('res://Game/UI/DamageNumbers/DamageNumber.tscn')
var experience = preload('res://Game/Experience/Experience.tscn')
	
func toggleVisibility(item: CanvasItem):
	if item.visible:
		item.hide()
	else:
		item.show()
		
func createDamageNumber(pos: Vector2, amount: int, color: String = 'ea323c'):
	var dn = damageNumber.instantiate()
	dn.text = str(amount)
	dn.modulate = color
	dn.global_position = pos
	get_tree().root.add_child(dn)
	var t = dn.create_tween()
	t.tween_property(dn, 'position:y', pos.y-10, 0.3)
	t.tween_property(dn, 'modulate:a', 0.0, 0.3).from(0.5)
	await get_tree().create_timer(0.5).timeout
	dn.queue_free()

func dropExperience(pos: Vector2, amount: int, parent: Node2D):
	for i in amount:
		randomize()
		
		var spawnCoords: Vector2 = Vector2(0,0)
		var ang = randi_range(0, 360)
		var poi = randi_range(10, 20)
		spawnCoords.x = pos.x + poi * cos(deg_to_rad(ang))
		spawnCoords.y = pos.y + poi * sin(deg_to_rad(ang))
		
		var exp = experience.instantiate()
		parent.call_deferred('add_child', exp)
		exp.global_position = pos
		
		var DOT = Vector2(1,0).dot((spawnCoords - pos).normalized())
		var angle = 90 - 45 * DOT
		
		var x_dis = spawnCoords.x - pos.x
		var y_dis = -1.0 * (spawnCoords.y - pos.y)
		
		var speed = sqrt(((0.5 * -9.8 * x_dis * x_dis) / pow(cos(deg_to_rad(angle)), 2.0)) / (y_dis - (tan(deg_to_rad(angle)) * x_dis)))
		var x_component = cos(deg_to_rad(angle)) * speed
		var y_component = sin(deg_to_rad(angle)) * speed
		
		var total_time = x_dis / x_component
		var curve = []
		
		for point in range(25.0):
			var time = total_time * (point / 25.0)
			var dx = time * x_component
			var dy = -1.0 * (time * y_component + 0.5 * -9.8 * time * time)
			curve.append(pos + Vector2(dx, dy))

		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).bind_node(exp)
		exp.tween = tween
		for p in curve:
			tween.tween_property(exp, 'position', p, 0.01)
