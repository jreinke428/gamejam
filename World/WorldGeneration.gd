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
		'objectTiles' : {},
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

var TerrainColors = [
	'ea323c', '5ac54f', 'ff5000', 'db3ffd'
]

#'tree': {'layer': 0, 'sourceId': 0, 'atlasCoords': Vector2.ZERO, 'alternativeTile': 1},
var ObjectTiles = {}

func _ready():
	chooseTerrainColor()
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
			
			# Grass is placed at every location
			placeBiomePlaceholderSurfaceTile('forest', worldPosition)
			placeBiomeObject('forest', worldPosition)
			Biomes.forest.area.append(worldPosition)
	
	# Fill all placeholder tiles with the correct terrain
	for biome in Biomes:
		for surfaceTile in Biomes[biome].surfaceTiles:
			set_cells_terrain_connect(Biomes[biome].layer, Biomes[biome].area, TerrainTiles[surfaceTile].terrainSet, TerrainTiles[surfaceTile].terrain, false)
			
	#FlowField.initializeAndGenerateFields()
	
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
			set_cell(ObjectTiles[tileName].layer, worldPosition, ObjectTiles[tileName].sourceId, ObjectTiles[tileName].atlasCoords, ObjectTiles[tileName].alternativeTile)
			return

func setSurfacePlaceholder(worldPosition: Vector2i, tileName: String, biome: String):
	set_cell(Biomes[biome].layer, worldPosition, 0, SurfacePlaceholderTiles[tileName], 0)

func between(val, start, end) -> bool:
	return start <= val and val < end # i think this still works
	
func chooseTerrainColor():
	set_layer_modulate(0, Color(TerrainColors[randf_range(0, TerrainColors.size())]))
