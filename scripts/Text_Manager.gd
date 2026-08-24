extends Node

var subtitle_instance = null
var text_label = null
var panel = null
var is_showing = false

func _ready():
	# Загружаем сцену отложенно, чтобы избежать конфликта
	var scene = load("res://scenes/SubtitleUI.tscn")
	subtitle_instance = scene.instantiate()
	
	# Добавляем отложенно
	get_tree().root.add_child.call_deferred(subtitle_instance)
	
	# Ждём один кадр, чтобы узлы успели создаться
	await get_tree().process_frame
	
	# Ищем узлы по правильным путям (проверь структуру!)
	panel = subtitle_instance.get_node("Background")
	text_label = subtitle_instance.get_node("Background/MarginContainer/TextLabel")
	
	if panel:
		panel.modulate.a = 0.0
	else:
		print("Text_Manager: Panel не найден!")

func show_text(text: String, speed: float = 0.05, duration: float = 2.0):
	if not panel or not text_label:
		print("Text_Manager: узлы не инициализированы")
		return
	if is_showing:
		stop()
	is_showing = true
	text_label.text = ""
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	await tween.finished
	for i in range(text.length()):
		text_label.text += text[i]
		if text[i] != " ":
			await get_tree().create_timer(speed).timeout
	await get_tree().create_timer(duration).timeout
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.2)
	await tween.finished
	is_showing = false
	text_label.text = ""

func stop():
	if not panel or not text_label:
		return
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.1)
	await tween.finished
	text_label.text = ""
	is_showing = false
