extends Node

var canvas: CanvasLayer = null
var bg: ColorRect = null
var label: Label = null
var is_showing: bool = false
var tween: Tween = null
var _initialized: bool = false
signal text_finished
func _ensure_initialized():
	if _initialized:
		return
	# Создаём CanvasLayer, чтобы текст всегда был поверх 2D и 3D миров
	canvas = CanvasLayer.new()
	canvas.layer = 10
	get_tree().root.add_child.call_deferred(canvas)
	
	# Ждём один кадр, чтобы Godot успел переварить новый слой
	await get_tree().process_frame
	
	# === НАСТРОЙКА ЧЁРНОЙ ПОЛОСЫ (ФОН) ===
	bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.75) # Симпатичный полупрозрачный чёрный цвет
	
	# Привязываем якоря намертво к НИЗУ экрана во всю ширину
	bg.anchor_left = 0.0
	bg.anchor_right = 1.0
	bg.anchor_top = 1.0
	bg.anchor_bottom = 1.0
	
	# Задаём идеальные отступы: высота ровно 120 пикселей, лежит чётко на полу
	bg.offset_left = 0
	bg.offset_right = 0
	bg.offset_top = -120 # Высота полосы уходит вверх от нижнего края экрана
	bg.offset_bottom = 0
	
	bg.modulate.a = 0.0
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(bg)
	
	# === НАСТРОЙКА БЕГУЩЕЙ СТРОКИ (ТЕКСТ) ===
	label = Label.new()
	label.text = ""
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Адаптивные якоря: текст занимает 100% пространства внутри чёрной полосы
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.anchor_top = 0.0
	label.anchor_bottom = 1.0
	
	# Отступы по краям полосы, чтобы текст не лип к границам экрана
	label.offset_left = 40
	label.offset_right = -40
	label.offset_top = 10
	label.offset_bottom = -10
	
	# Включаем автоматический перенос длинных слов, чтобы текст не улетал вбок!
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Выкручиваем сочный хоррор-шрифт
	label.add_theme_font_size_override("font_size", 26)
	label.add_theme_color_override("font_color", Color.WHITE)
	bg.add_child(label)
	
	_initialized = true

func show_text_and_bred(text: String, speed: float = 0.04, duration: float = 2.0):
	if not _initialized:
		await _ensure_initialized()
	if is_showing:
		stop()
	is_showing = true
	label.text = ""
	bg.modulate.a = 0.0
	bg.show()
	
	tween = create_tween()
	tween.tween_property(bg, "modulate:a", 1.0, 0.2)
	await tween.finished
	
	for i in range(text.length()):
		label.text += text[i]
		if text[i] != " ":
			await get_tree().create_timer(speed).timeout
		else:
			await get_tree().create_timer(speed * 0.3).timeout
	
	await get_tree().create_timer(duration).timeout
	
	tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.0, 0.2)
	await tween.finished
	bg.hide()
	is_showing = false

func show_text(text: String, speed: float = 0.04, duration: float = 2.0):
	if not _initialized:
		await _ensure_initialized()
	
	# Мгновенно рубим все старые процессы печати и таймеры
	stop()
	
	is_showing = true
	
	# Сразу закидываем ЦЕЛЫЙ текст в память лейбла (скрывая все буквы)
	label.text = text
	label.visible_characters = 0 
	bg.modulate.a = 0.0
	bg.show()
	
	# === ВЕСЬ ПРОЦЕСС В ОДНОМ ТВИНЕ (Асинхронная цепочка) ===
	tween = create_tween()
	
	# 1. Плавно проявляем черную полосу за 0.2 сек
	tween.tween_property(bg, "modulate:a", 1.0, 0.2)
	
	# 2. Анимируем появление букв (от 0 до полной длины строки)
	# Время анимации = количество букв * скорость
	var typing_duration = text.length() * speed
	tween.tween_property(label, "visible_characters", text.length(), typing_duration)
	
	# 3. Делаем паузу (время удержания текста на экране)
	tween.tween_interval(duration)
	
	# 4. Плавно скрываем черную полосу обратно в прозрачность за 0.2 сек
	tween.tween_property(bg, "modulate:a", 0.0, 0.2)
	
	# 5. Когда вся цепочка твина завершилась — убираем видимость и сбрасываем флаг
	tween.tween_callback(func():
		bg.hide()
		label.text = ""
		is_showing = false
		text_finished.emit()
	)
	

func stop():
	# Твины в Godot 4 убивают ВСЮ цепочку (и анимацию, и паузы, и колбэки)
	if tween and tween.is_valid():
		tween.kill()
		tween = null
	
	if bg:
		bg.modulate.a = 0.0
		bg.hide()
	if label:
		label.text = ""
		label.visible_characters = -1 # -1 означает показывать все буквы по дефолту
	is_showing = false
