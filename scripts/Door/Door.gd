extends Area2D
@export var sound_player: AudioStreamPlayer2D = null
func interact():
	print("Дверь: Активируем переход через GameManager!")
	if GlobalVars.isFinal:
		Subtitle.show_text("Since I've come all the way back, I might as well stay for the night shift. Good thing my schedule allows it.")
		return
	if sound_player:
		sound_player.play()
	# Вызываем твою ультимативную функцию! Имя менеджера пишем СЛИТНО
	GameManager.switch_to_scene("res://scenes/улица.tscn", Color.BLACK, 0.5)
