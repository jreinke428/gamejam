extends Node

var SCREEN_SIZE:= Vector2i(96, 54)

var PLANETS := [
	{
		'texture' : preload("res://UI/Start/start-planet-1.png"),
		'color' : 'ff5000'
	},
	{
		'texture' : preload("res://UI/Start/start-planet-2.png"),
		'color' : 'db3ffd'
	},
	{
		'texture' : preload("res://UI/Start/start-planet-3.png"),
		'color' : '5ac54f'
	},
	{
		'texture' : preload("res://UI/Start/start-planet-4.png"),
		'color' : 'ea323c'
	},
	{
		'texture' : preload("res://UI/Start/start-planet-5.png"),
		'color' : '787878'
	},
]

var PLANTS = [
	{
		'texture' : null
	},
	{
		'texture' : null
	},
	{
		'texture' : null
	}
]

var ENEMIES = [
	{
		'scene' : preload('res://Enemies/Enemy1/Enemy1.tscn'),
		'texture' : preload('res://Enemies/Enemy1/enemy1-ui.png')
	},
	{
		'scene' : preload('res://Enemies/Enemy1/Enemy1.tscn'),
		'texture' : preload('res://Enemies/Enemy1/enemy1-ui.png')
	},
	{
		'scene' : preload('res://Enemies/Enemy1/Enemy1.tscn'),
		'texture' : preload('res://Enemies/Enemy1/enemy1-ui.png')
	},
]

var currentState = {
	'planet' : null,
	'plant' : null,
	'enemy' : null
}
	
