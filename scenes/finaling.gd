extends Area2D

var triggered: bool = false

func _ready():
	# Привязываем авто-сигнал входа
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Как только Player2D пересекает черту
	if body.name == "Player2D" and not triggered:
		triggered = true
		print("МЕНЕДЖЕР СЦЕН: Игрок вошёл. Автоматически собираем компоненты финальной катсцены!")
		_trigger_bad_ending_cutscene(body)

func _trigger_bad_ending_cutscene(player: Node2D):
	# 1. Отключаем управление игрока
	player.set_physics_process(false) 
	
	# АВТО-ПОИСК: Ищем камеру и спрайт прямо внутри вошедшего игрока (body)!
	# Убедись, что имена нод внутри твоего игрока совпадают (Camera2D и Sprite2D или как SeeSharp их назвал)
	var camera = player.find_child("Camera2D", true, false) as Camera2D
	
	# Если спрайт обезьяны — это сам аватар игрока, берём его. Иначе ищем по имени ноды
	var monkey_sprite = player.find_child("Sprite2D", true, false)
	if not monkey_sprite:
		monkey_sprite = player.find_child("AnimatedSprite2D", true, false)

	# 2. ЗВУК: Раз звука на сцене нет, мы создаём звуковой плеер КРЕМ ПРЯМО ИЗ КОДА!
	var sound_player = AudioStreamPlayer.new()
	add_child(sound_player)
	# Перетащи свой файл скримера в инспекторе триггера в поле ниже, если хочешь, 
	# либо просто загрузи любой mp3/wav файл из папки проекта:
	sound_player.stream = load("res://sound/glitch_screamer.mp3") # Поменяй путь на свой аудиофайл!
	sound_player.play()
	
	# 3. КИНЕМАТОГРАФИЧНЫЙ УЛЕТ КАМЕРЫ В НЕБО ЧЕРЕЗ ТВИНИНГ
	if camera:
		var current_global_pos = camera.global_position
		# Разрываем привязку к игроку, чтобы камера взлетела
		camera.top_level = true
		camera.global_position = current_global_pos
		var tween = create_tween()
		var target_sky_position = camera.global_position + Vector2(3892.0, -3000.0)
		
		# Камера со сглаживанием плавно улетает вверх за 2.0 секунды!
		tween.tween_property(camera, "global_position", target_sky_position, 10.0)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_IN_OUT)
			
		await tween.finished
	
	# 4. ВСПЫШКА КРАСНОГО ГЛИТЧА И ПОЯВЛЕНИЕ ОБЕЗЬЯНЫ
	if Effects.has_method("flash"):
		Effects.flash()
	ShaderManager.fade_insanity(0.3, 2.0) # Багровый приход!
	await get_tree().create_timer(1.0).timeout
	
	ShaderManager.fade_insanity(0.0, 0.5)
	ShaderManager.fade_desaturation(0.0, 0.5)
	
	# Финальный текст «Плохуй» концовки
	Subtitle.show_text("Perhaps you have left your shift, but have you truly run away from yourself?")
	await Subtitle.text_finished
	Subtitle.show_text("To be continued...")
	await Subtitle.text_finished
	
	# Возвращаем камеру игроку перед перезагрузкой
	if camera:
		camera.top_level = false
	
	# Конец демки — мягкий релоад сцены
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
