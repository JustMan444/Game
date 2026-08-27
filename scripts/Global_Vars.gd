extends Node

var player_health = 100
var player_max_health = 100
var inventory = []
var player_position_2d = Vector2.ZERO
var player_position_3d = Vector3.ZERO
var current_level = "res://scenes/main.tscn"
var coins = 0
var is_transitioning = false
var isNeed = true
var helped_homeless = false
# Хранилище позиции игрока на улице
var player_street_position: Vector2 = Vector2.ZERO
var teleport_count: int = 0
var bug_portal_used: bool = false # Был ли уже использован портал безумия
var bug_portal_used1: bool = false 
var why: bool = false 

	
	
	
