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
		Subtitle.show_text("Have you never thought that you’re simply trying to run away from judgment?")
		await Subtitle.text_finished
		Subtitle.show_text("Why do you try so hard to be normal in the eyes of others?")
		await Subtitle.text_finished
		Subtitle.show_text("Because that’s just how it’s done? Because you’re terrified of being judged?")
		await Subtitle.text_finished
		Subtitle.show_text("Why do you deny yourself the simplest everyday pleasures just to look normal in the eyes of society?")
		await Subtitle.text_finished
		Subtitle.show_text("Why are you trying to run away from yourself?")
func move_chair_smoothly():
	var tween = create_tween()
	# Плавно двигаем объект в точку (X: 500, Y: 300) за 2.5 секунды с красивым замедлением
	tween.tween_property(self, "position", Vector3(0, 0,-6000), 800).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
