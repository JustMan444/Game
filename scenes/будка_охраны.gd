extends Node2D


func _ready():
	if GlobalVars.isFinal:
		print("БУДКА ОХРАНЫ: Истинный финал активен. Ставим игрока у двери!")
		var player = find_child("Player2D", true, false) as Node2D
		if player:
			player.global_position = Vector2(-5485.0, 768) 
			print("БУДКА ОХРАНЫ: Позиция успешно скорректирована.")
