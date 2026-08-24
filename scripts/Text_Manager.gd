extends Node

var subtitle_scene = preload("res://scenes/глист_мистер_биста.tscn")
var subtitle_instance = null
var text_label = null
var panel = null
var is_showing = false

func _ready():
	# Создаём экземпляр сцены и добавляем на root
	subtitle_instance = subtitle_scene.instantiate()
	get_tree().root.add_child(subtitle_instance)
	
	# Находим узлы
	panel = subtitle_instance.get_node("Background")
	text_label = subtitle_instance.get_node("Background/MarginContainer/TextLabel")
	
	# Изначально скрыты
	panel.modulate.a = 0.0
	text_label.text = ""

# Показать текст с эффектом печати
func show_text(text: String, typing_speed: float = 0.05, display_duration: float = 2.0):
	if is_showing:
		# Если уже показываем, прерываем и сразу показываем новый
		stop()
	
	is_showing = true
	text_label.text = ""  # очистить
	
	# Плавно появиться
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)
	await tween.finished
	
	# Печатаем текст
	var full_text = text
	var current_text = ""
	for i in range(full_text.length()):
		current_text += full_text[i]
		text_label.text = current_text
		# Если это не пробел, делаем небольшую паузу
		if full_text[i] != " ":
			await get_tree().create_timer(typing_speed).timeout
		else:
			# Можно сделать паузу короче или без паузы
			await get_tree().create_timer(typing_speed * 0.5).timeout
	
	# Ждём указанное время
	await get_tree().create_timer(display_duration).timeout
	
	# Плавно исчезаем
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	await tween.finished
	is_showing = false
	text_label.text = ""

# Принудительно остановить и скрыть
func stop():
	if subtitle_instance:
		var tween = get_tree().create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.2)
		await tween.finished
		text_label.text = ""
		is_showing = false
