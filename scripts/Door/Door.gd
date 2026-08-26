extends Area2D
@export var sound_player: AudioStreamPlayer2D = null
func interact():
	print("Дверь: Активируем переход через GameManager!")
	if sound_player:
		sound_player.play()
	# Вызываем твою ультимативную функцию! Имя менеджера пишем СЛИТНО
	GameManager.switch_to_scene("res://scenes/улица.tscn", Color.BLACK, 0.5)
