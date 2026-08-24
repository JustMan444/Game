extends Node

var subtitle_instance = null
var text_label = null
var panel = null 
var is_showing = false

func _ready():
	# Загружаем сцену
	var scene = load("res://scenes/SubtitleUI.tscn")
	subtitle_instance = scene.instantiate()
	
	# Добавляем в дерево ОТЛОЖЕННО (чтобы избежать конфликтов)
	get_tree().root.add_child.call_deferred(subtitle_instance)
	
	# Ждём один кадр, чтобы узлы успели инициализироваться
	await get_tree().process_frame
	
	# Теперь ищем узлы (они уже в дереве)
	panel = subtitle_instance.get_node("Background")
	text_label = subtitle_instance.get_node("Background/MarginContainer/RichTextLabel")
	var margin_container = subtitle_instance.get_node("Background/MarginContainer")
	
	if panel and text_label and margin_container:
		panel.modulate.a = 0.0
		
		# === ВСТРОЕННАЯ ИДЕАЛЬНАЯ АДАПТИВНОСТЬ GODOT 4 ===
		# Сбрасываем кривые масштабы из инспектора
		panel.scale = Vector2.ONE
		margin_container.scale = Vector2.ONE
		text_label.scale = Vector2.ONE
		
		# 1. Заставляем плашку Background встать намертво вниз экрана во всю ширину
		panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
		panel.size.y = 120 # Жестко задаем высоту полосы субтитров в пикселях
		
		# 2. Заставляем MarginContainer полностью растянуться во весь родительский Background
		margin_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		
		# Настройки самого текста
		text_label.fit_content = false
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text_label.add_theme_font_size_override("normal_font_size", 24) # Нормальный шрифт субтитров
		
		print("Text_Manager: Система адаптивного UI через встроенные пресеты Godot 4 запущена!")
	else:
		print("Text_Manager: КРИТИЧЕСКАЯ ОШИБКА ИНИЦИАЛИЗАЦИИ УЗЛОВ!")



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
