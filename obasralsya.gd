extends Area3D

# Переменная-предохранитель, чтобы триггер сработал строго ОДИН раз за игру
var triggered: bool = false

func _ready():
	# НАМЕРТВО привязываем сигнал входа к коду. 
	# Godot сам вызовет функцию ниже, как только кто-то наступит на коллизию!
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Защита: срабатывает только если вошел ИГРОК и триггер еще не был нажат
	if body.name == "Player3D" and not triggered:
		triggered = true
		move_chair_smoothly()
func move_chair_smoothly():
	var tween = create_tween()
	# Плавно двигаем объект в точку (X: 500, Y: 300) за 2.5 секунды с красивым замедлением
	tween.tween_property(self, "position", Vector3(0, 0,-6000), 800).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
