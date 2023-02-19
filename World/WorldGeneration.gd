##
# 1. Surface should have as many layers as there are biomes.
# 2. Each surface tile should have a terrain set up for that tile.
# 
# Surface tiles are tiles that are considered as the ground or base of the world
# Object tiles are the objects that can spawn when the world is created
# 
##

extends TileMap

var noise: FastNoiseLite

## All spawnable biomes
## All tiles inside surfaceTiles and objectTiles should be contained within Tiles
var Biomes = {
	'water': {
		'maxAltitude': 0.17,
		'layer': 1,
		'surfaceTiles': {'water': 100.0},
		'objectTiles' : {},
		'area': []
	},
	'forest': {
		'maxAltitude': 1.0,
		'layer': 0,
		'surfaceTiles': {'grass': 100.0},
		'objectTiles' : {'plant': 0.5, "tree": 3.0, "rock1": 1.5, "rock2": 1.5, "worms": 3.0, "glamujobe": 3.0},
		'area': []
	}
}

## Placeholder tiles need to be at Source ID 0 on the Surface TileSet
## Tile names need to match the tile names inside of each biome's surfaceTiles.
var SurfacePlaceholderTiles = {
	'water': Vector2i(2, 0),
	'grass': Vector2i(5, 0) 
}

## Terrain (autotile) data for each surface tile.
## Each surface tile needs to have a terrain set up, even if there are no autotiles for that tile yet.
##	Draw a 3x3 bitmap over the single tile if there is no autotile mask set up yet.
var TerrainTiles = {
	'water':  {'terrainSet': 0, 'terrain': 0},
	'grass': {'terrainSet': 0, 'terrain': 1},
}

#'tree': {'layer': 0, 'sourceId': 0, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 1},
var ObjectTiles = {
	"plant": {'layer': 2, 'sourceId': 7, 'atlasCoords': Vector2.ZERO, 'alternativeTile': GlobalProperties.currentState.plant.tile},
	"tree": {'layer': 3, 'sourceId': 7, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 1},
	"scanner": {'layer': 4, 'sourceId': 7, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 5},
	"rock1": {'layer': 3, 'sourceId': 3, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 0},
	"rock2": {'layer': 3, 'sourceId': 4, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 0},
	"worms": {'layer': 3, 'sourceId': 5, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 0},
	"glamujobe": {'layer': 3, 'sourceId': 6, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 0},
}

func _ready():
	FlowField.worldMap = self
	setTerrainColor()
	generateTerrain()

func clearWorldTileMaps():
	for node in get_children():
		node.free()
	clear()

func initializeNoise():
	noise = FastNoiseLite.new()
	noise.set_seed(randi())
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	noise.set_fractal_gain(0.4)
	noise.set_fractal_octaves(3)
	noise.set_frequency(0.04)

func generateTerrain(screenSize: Vector2i = GlobalProperties.SCREEN_SIZE):
	initializeNoise()
	
	# Place down placeholder tiles for each surface tile
	for x in range(screenSize.x):
		for y in range(screenSize.y):
			var altitude = abs(noise.get_noise_2d(x, y))
			var worldPosition = Vector2i(x, y)
			if altitude < Biomes.water.maxAltitude:
				placeBiomePlaceholderSurfaceTile('water', worldPosition)
				placeBiomeObject('water', worldPosition)
				Biomes.water.area.append(worldPosition)
			else:
				placeBiomeObject('forest', worldPosition)
			
			# Grass is placed at every location
			placeBiomePlaceholderSurfaceTile('forest', worldPosition)
			Biomes.forest.area.append(worldPosition)
	
	# Fill all placeholder tiles with the correct terrain
	for biome in Biomes:
		for surfaceTile in Biomes[biome].surfaceTiles:
			set_cells_terrain_connect(Biomes[biome].layer, Biomes[biome].area, TerrainTiles[surfaceTile].terrainSet, TerrainTiles[surfaceTile].terrain, false)
			
	FlowField.initializeFields()
	
## This function may not work if you try and place down two different tiles within the biome
func placeBiomePlaceholderSurfaceTile(biome: String, worldPosition: Vector2i):
	var spawnRates = Biomes[biome].surfaceTiles # Tiles contained within biome
	var roll = randf_range(0, 100)
	var total = 0.0
	for tileName in spawnRates:
		total += spawnRates[tileName]
		if roll <= total:
			setSurfacePlaceholder(worldPosition, tileName, biome)
			return

func placeBiomeObject(biome: String, worldPosition: Vector2i):
	var spawnRates = Biomes[biome].objectTiles
	var roll = randf_range(0, 100)
	var total = 0.0
	for tileName in spawnRates:
		total += spawnRates[tileName]
		if roll <= total:
			placeObject(tileName, worldPosition)
			return
			
func placeObject(tileName: String, worldPosition: Vector2i):
	set_cell(ObjectTiles[tileName].layer, worldPosition, ObjectTiles[tileName].sourceId, ObjectTiles[tileName].atlasCoords, ObjectTiles[tileName].alternativeTile)

func setSurfacePlaceholder(worldPosition: Vector2i, tileName: String, biome: String):
	set_cell(Biomes[biome].layer, worldPosition, 0, SurfacePlaceholderTiles[tileName], 0)

func between(val, start, end) -> bool:
	return start <= val and val < end # i think this still works
	
func setTerrainColor():
	set_layer_modulate(0, GlobalProperties.currentState.planet.color)

func isInWater(pos):
	var mapPos = local_to_map(pos)
	if get_cell_source_id(1, mapPos) != -1:
		if get_cell_source_id(1, mapPos+Vector2i.UP) == -1 and int(pos.y) % 16 < 4: return false
		if get_cell_source_id(1, mapPos+Vector2i.RIGHT) == -1 and int(pos.x) % 16 > 12: return false
		if get_cell_source_id(1, mapPos+Vector2i.DOWN) == -1 and int(pos.y) % 16 > 10: return false
		if get_cell_source_id(1, mapPos+Vector2i.LEFT) == -1 and int(pos.x) % 16 < 4: return false
		if get_cell_source_id(1, mapPos+Vector2i.UP+Vector2i.RIGHT) == -1 and int(pos.y) % 16 < 4 and int(pos.x) % 16 > 12: return false
		if get_cell_source_id(1, mapPos+Vector2i.RIGHT+Vector2i.DOWN) == -1 and int(pos.x) % 16 > 12 and int(pos.y) % 16 > 10: return false
		if get_cell_source_id(1, mapPos+Vector2i.DOWN+Vector2i.LEFT) == -1 and int(pos.y) % 16 > 10 and int(pos.x) % 16 < 4: return false
		if get_cell_source_id(1, mapPos+Vector2i.LEFT+Vector2i.UP) == -1 and int(pos.x) % 16 < 4 and int(pos.y) % 16 < 4: return false
		return true
	return false
	
func isValidSpawn(pos):
	if isInWater(pos): return false
	if pos.x < 0 or pos.x/16 > GlobalProperties.SCREEN_SIZE.x: return false
	if pos.y < 0 or pos.y/16 > GlobalProperties.SCREEN_SIZE.y: return false
	return true

