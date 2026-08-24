extends Area2D

func interact():
	print("Дверь: Активируем переход через GameManager!")
	
	# Вызываем твою ультимативную функцию! Имя менеджера пишем СЛИТНО
	GameManager.switch_to_scene("res://scenes/world.tscn", Color.BLACK, 0.5)
