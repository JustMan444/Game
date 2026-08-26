extends Area2D

# Переменная-предохранитель, чтобы триггер сработал строго ОДИН раз за игру
var triggered: bool = false

func _ready():
	# НАМЕРТВО привязываем сигнал входа к коду. 
	# Godot сам вызовет функцию ниже, как только кто-то наступит на коллизию!
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Защита: срабатывает только если вошел ИГРОК и триггер еще не был нажат
	if body.name == "Player2D" and not triggered:
		triggered = true
		ShaderManager.fade_insanity(0.5, 1.0)
		ShaderManager.fade_desaturation(2,4)
		GlobalVars.player_street_position = body.global_position
		GameManager.switch_to_scene("res://bug.tscn", Color.DARK_RED, 0.001)
