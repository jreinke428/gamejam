extends Node

var SCREEN_SIZE:= Vector2i(96, 54)

var PLANETS := [
	{
		'texture' : preload("res://Game/GameScenes/Start/start-planet-1.png"),
		'color' : 'orange'
	},
	{
		'texture' : preload("res://Game/GameScenes/Start/start-planet-2.png"),
		'color' : 'purple'
	},
	{
		'texture' : preload("res://Game/GameScenes/Start/start-planet-3.png"),
		'color' : 'green'
	},
	{
		'texture' : preload("res://Game/GameScenes/Start/start-planet-4.png"),
		'color' : 'red'
	},
	{
		'texture' : preload("res://Game/GameScenes/Start/start-planet-5.png"),
		'color' : 'white'
	},
]

var PLANTS = [
	{
		'texture' : preload("res://World/Flora/ScannablePlants/Plant1/alien-plant-1.png"),
		'tile' : 2
	},
	{
		'texture' : preload("res://World/Flora/ScannablePlants/Plant2/alien-plant-2.png"),
		'tile' : 3
	},
	{
		'texture' : preload("res://World/Flora/ScannablePlants/Plant3/alien-plant-3.png"),
		'tile' : 4
	}
]

var ENEMIES = [
	{
		'scene' : preload('res://World/Enemies/Enemy1/Enemy1.tscn'),
		'texture' : preload('res://World/Enemies/Enemy1/enemy1-ui.png')
	},
	{
		'scene' : preload('res://World/Enemies/Enemy2/Enemy2.tscn'),
		'texture' : preload('res://World/Enemies/Enemy2/enemy2-ui.png')
	},
	{
		'scene' : preload('res://World/Enemies/Enemy3/Enemy3.tscn'),
		'texture' : preload('res://World/Enemies/Enemy3/enemy3-ui.png')
	},
]

var currentState = {
	'planet' : null,
	'plant' : null,
	'enemy' : null
}

var playerStats = {
	'damage' : 2,
	'fireRate' : 0.5,
	'pierce' : 1
}
	
