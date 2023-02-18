extends Node

@onready var surfaceMap : TileMap = $"/root/Test/World"
@onready var player : CharacterBody2D = $'/root/Test/World/Player'

var spawningEnemies = false
var scanPos = null
var curEnemy = null
var texture = preload('res://icon.svg')
var spawnParticles = preload('res://Util/Particles/SpawnParticles.tscn')

func _process(delta):
	if (Input.is_action_just_released("ui_text_backspace")): 
		spawningEnemies = !spawningEnemies
		scanPos = player.global_position
		FlowField.setTarget(player.global_position)
	if (spawningEnemies): spawnEnemies()

func isInWater(pos):
	var mapPos = surfaceMap.local_to_map(pos)
	if surfaceMap.get_cell_source_id(1, mapPos) != -1:
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.UP) == -1 and int(pos.y) % 16 < 4: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.RIGHT) == -1 and int(pos.x) % 16 > 12: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.DOWN) == -1 and int(pos.y) % 16 > 10: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.LEFT) == -1 and int(pos.x) % 16 < 4: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.UP+Vector2i.RIGHT) == -1 and int(pos.y) % 16 < 4 and int(pos.x) % 16 > 12: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.RIGHT+Vector2i.DOWN) == -1 and int(pos.x) % 16 > 12 and int(pos.y) % 16 > 10: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.DOWN+Vector2i.LEFT) == -1 and int(pos.y) % 16 > 10 and int(pos.x) % 16 < 4: return false
		if surfaceMap.get_cell_source_id(1, mapPos+Vector2i.LEFT+Vector2i.UP) == -1 and int(pos.x) % 16 < 4 and int(pos.y) % 16 < 4: return false
		return true
	return false
	
func toggleVisibility(item: CanvasItem):
	if item.visible:
		item.hide()
	else:
		item.show()

func isValidSpawn(pos):
	if isInWater(pos): return false
	if pos.x < 0 or pos.x/16 > GlobalProperties.SCREEN_SIZE.x: return false
	if pos.y < 0 or pos.y/16 > GlobalProperties.SCREEN_SIZE.y: return false
	return true

func spawnEnemies():
	if randf() < 0.05:
		var dist = randf_range(100,150)
		var angle = randf_range(0,360)
		var coords = Vector2(cos(angle)*dist, sin(angle)*dist)
		print(coords)
		while(!isValidSpawn(scanPos+coords)):
			dist = randf_range(100,150)
			angle = randf_range(0,360)
			coords = Vector2(cos(angle)*dist, sin(angle)*dist)
		spawnEnemy(scanPos+coords)

func spawnEnemy(pos):
	var particles : GPUParticles2D = spawnParticles.instantiate()
	particles.global_position = pos
	particles.emitting = true
	particles.z_index += 1
	get_tree().root.add_child(particles)
	await get_tree().create_timer(1.0).timeout 
	var enemy = Sprite2D.new()
	enemy.texture = texture
	enemy.global_position = pos
	get_tree().root.add_child(enemy)
	enemy.create_tween().tween_property(enemy, 'scale', Vector2(0.1, 0.1), 0.5).from(Vector2(0.01,0.01))
		
		
