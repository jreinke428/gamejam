extends Node

var MAP_SIZE = GlobalProperties.SCREEN_SIZE # Assumes world is a circle
var CELL_SIZE = 16
var MAX_INT = 65535
var MAX_COST = 511
var COST_FIELD = Dictionary()
var INTEGRATION_FIELD = Dictionary()
var FLOW_FIELD = Dictionary()
var vectors = Node2D.new()
var worldMap
var targetPos

func initializeFields():
	initializeCostField()
	
func setTarget(pos):
	targetPos = Vector2i(pos/CELL_SIZE)
	initializeIntegrationField()
	initializeFlowField()
	generateIntegrationField()
	generateFlowField()
	#clearVectors()
	#showVectors()
			
func initializeCostField():
	# initialize costs of cells
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			var pos = Vector2i(x,y)
			if worldMap.get_cell_source_id(1, pos) != -1:
				COST_FIELD[Vector2i(x,y)] = 3
			elif worldMap.get_cell_source_id(3, pos) != -1:
				COST_FIELD[Vector2i(x,y)] = MAX_COST
			else:
				COST_FIELD[Vector2i(x,y)] = 1
			
func initializeIntegrationField():
	# initialize the integration field		
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			INTEGRATION_FIELD[Vector2i(x,y)] = MAX_INT
			
func initializeFlowField():
	# initialize the integration field		
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			FLOW_FIELD[Vector2i(x,y)] = Vector2.ZERO
			
func generateIntegrationField():
	# use breadth first search to create djikstra map on integration field
	var queue = []
	INTEGRATION_FIELD[targetPos] = 0
	queue.append(targetPos)
	while queue.size() > 0:
		var curPos = queue.pop_front()
		for neighbor in getAdjacentNeighbors(curPos):
			if COST_FIELD[neighbor] == MAX_COST: continue
			var cost = INTEGRATION_FIELD[curPos] + COST_FIELD[neighbor]
			if cost < INTEGRATION_FIELD[neighbor]:
				if !queue.has(neighbor):
					queue.append(neighbor)
				INTEGRATION_FIELD[neighbor] = cost
				
func generateFlowField():
	# create flow field from integration field
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			var curPos = Vector2i(x,y)
			var neighbors = getAllNeighbors(curPos)
			var minNeighbor = neighbors[0]
			var minCost = INTEGRATION_FIELD[minNeighbor]
			for i in range(1,neighbors.size()):
				if INTEGRATION_FIELD[neighbors[i]] < minCost:
					minNeighbor = neighbors[i]
					minCost = INTEGRATION_FIELD[neighbors[i]]
			FLOW_FIELD[curPos] = Vector2(minNeighbor-curPos).normalized()
	FLOW_FIELD[targetPos] = Vector2.ZERO
			
func getAdjacentNeighbors(pos):
	var neighbors = []
	if pos.x < MAP_SIZE.x-1: neighbors.append(pos+Vector2i(1,0))
	if pos.x > 0: neighbors.append(pos+Vector2i(-1,0))
	if pos.y < MAP_SIZE.y-1: neighbors.append(pos+Vector2i(0,1))
	if pos.y > 0: neighbors.append(pos+Vector2i(0,-1))
	return neighbors
	
func getAllNeighbors(pos):
	var neighbors = []
	if pos.x < MAP_SIZE.x-1: 
		neighbors.append(pos+Vector2i(1,0))
		if pos.y > 0: neighbors.append(pos+Vector2i(1,-1))
		if pos.y < MAP_SIZE.y-1: neighbors.append(pos+Vector2i(1, 1))
	if pos.x > 0: 
		neighbors.append(pos+Vector2i(-1,0))
		if pos.y > 0: neighbors.append(pos+Vector2i(-1,-1))
		if pos.y < MAP_SIZE.y-1: neighbors.append(pos+Vector2i(-1, 1))
	if pos.y < MAP_SIZE.y-1: neighbors.append(pos+Vector2i(0,1))
	if pos.y > 0: neighbors.append(pos+Vector2i(0,-1))
	return neighbors

func getVector(pos):
	# V(x,y) = (1-a)(1-b)V(i,j) + a(1-b)V(i+1,j) + (1-a)bV(i,j+1) + abV(i+1,j+1)
	return FLOW_FIELD[Vector2i(pos/CELL_SIZE)]
	
func showVectors():	
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			var point = Vector2i(x,y)
			var line = Line2D.new()
			line.width = 2
			line.add_point(Vector2.ZERO)
			line.add_point(FLOW_FIELD[point]*8)
			line.global_position = Vector2(x*CELL_SIZE+CELL_SIZE/2, y*CELL_SIZE+CELL_SIZE/2)
			vectors.add_child(line)
			
func clearVectors():
	vectors.free()
	vectors = Node2D.new()
	get_tree().root.add_child.call_deferred(vectors)
