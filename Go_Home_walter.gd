extends Area3D

# Переменная-предохранитель, чтобы триггер сработал строго ОДИН раз за игру
var triggered: bool = false
@export var sound_player: AudioStreamPlayer3D = null
func _ready():
	# НАМЕРТВО привязываем сигнал входа к коду. 
	# Godot сам вызовет функцию ниже, как только кто-то наступит на коллизию!
	
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node):
	# Защита: срабатывает только если вошел ИГРОК и триггер еще не был нажат
	if body.name == "Player3D" and not triggered:
		triggered = true
		if sound_player:
			sound_player.play()
			print("Lol kek cheburek")
		GameManager.switch_to_scene("res://scenes/level.tscn",Color.DARK_RED, 0.00001)	
