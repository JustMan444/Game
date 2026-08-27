extends Node2D

func _ready():
	var player = find_child("Player2D", true, false)
	
	if player and GlobalVars.player_street_position != Vector2.ZERO:
		player.global_position = GlobalVars.player_street_position
		print("Игрок успешно возвращен на прошлую позицию!")
