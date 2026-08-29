extends Area2D

@export var cat_sprite: Node2D = null
@export var jump_texture: Texture2D = null
@export var sit_texture: Texture2D = null

func interact():
	if GlobalVars.isFinal:
		print("ЧАЙНИК: Игрок нажал Е. Запуск Истинной концовки!")
		_start_tea_cutscene()
		return

	Subtitle.show_text("(The tea is so cold that it makes my soul sad... and I love tea, but since I'm at work and not paying for electricity, I can just turn the kettle back on later!)",0.09,10)
func _start_tea_cutscene():
	# 1. Ищем игрока на сцене и намертво замораживаем его у стола
	var player = get_tree().current_scene.find_child("Player2D", true, false)
	if player:
		player.set_physics_process(false)
		
	# 2. ВКЛЮЧАЕМ ЗВУК ЧАЙНИКА
	var kettle_audio = AudioStreamPlayer.new()
	add_child(kettle_audio)
	MusicManager.final_volume_db = 3	
	MusicManager.play_special_song("res://assets/audio/Унесенные Ветром - Какао (hitmos.fm).mp3")
	kettle_audio.stream = load("res://assets/audio/the-electric-kettle-boils (mp3cut.net).mp3") # Твой путь к звуку чайника!
	if kettle_audio.stream:
		kettle_audio.volume_db = -5.0
		kettle_audio.play()

	
	# 3. ВОЗВРАТ ЦВЕТОВ И УБОРКА КРАСНОТЫ (плавно за 4 секунды)
	if ShaderManager.has_method("fade_desaturation"):
		ShaderManager.fade_desaturation(0.0, 4.0)
	if ShaderManager.has_method("fade_insanity"):
		ShaderManager.fade_insanity(0.0, 4.0)
		ShaderManager.fade_grain(0.0,5.0)
		
	# Честно ждём 4 секунды, пока мир расцветает под свист чайника
	await get_tree().create_timer(4.0).timeout
	
	# Переходим к Шагу 3 — финальный монолог и анимации
	_trigger_final_monologue()

func _trigger_final_monologue():
	print("КАТСЦЕНА ЧАЯ: Запуск финального монолога, прыжка кота и улета в небо...")
	
	# Авто-поиск ноды камеры и котика на сцене будки охраны
	var camera = get_tree().current_scene.find_child("Camera2D", true, false) as Camera2D
	
	# === ТВОЙ И jasudas ГЛУБОКИЙ ФИНАЛЬНЫЙ ТЕКСТ ПОД СВИСТ ЧАЙНИКА ===
	Subtitle.show_text("(Maybe I didn't make such a bad choice after all... it's cozy and peaceful here, and they'll even give me a pay raise!)")
	await Subtitle.text_finished
	
	Subtitle.show_text("The kettle is boiling. Hot steam rises to the ceiling, warming you up on this cold winter evening.")
	await Subtitle.text_finished
	
	# ШАГ 1: КОТИК ПРЫГАЕТ НА СТОЛ!
		# ШАГ 1: КАРТИНКА КОТА ПРЫГАЕТ НА СТОЛ К ЧАЙНИКУ!
	Subtitle.show_text("Your cat purrs softly on the old chair, welcoming you back.")
	if cat_sprite:
		# 1. Меняем спрайт на прыгающий прямо перед взлётом
		if jump_texture:
			cat_sprite.texture = jump_texture
			print("КАТСЦЕНА ЧАЯ: Спрайт кота изменен на прыгающий!")

		var cat_tween = create_tween()
		# Кот летит на стол рядом с чайником (позиция чайника минус 80 пикселей влево)
		var table_position = self.global_position + Vector2(-80.0, 0.0)
		
		# Картинка кота плавно взмывает по красивой дуге за 1.2 секунды
		cat_tween.tween_property(cat_sprite, "global_position", table_position, 1.2)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
			
		# 2. Как только Твин ПОЛНОСТЬЮ ЗАВЕРШИЛСЯ — подсовываем третью картинку сидящего на столе кота!
		cat_tween.tween_callback(func():
			if sit_texture:
				cat_sprite.texture = sit_texture
				print("КАТСЦЕНА ЧАЯ: Кот приземлился, включен финальный сидячий спрайт!")
		)
		
	await Subtitle.text_finished
	
	Subtitle.show_text("You pour yourself a hot cup of tea. Right from the kettle. To hell with their rules.")
	await Subtitle.text_finished
	
	# ШАГ 2: КИНЕМАТОГРАФИЧНЫЙ УЛЕТ КАМЕРЫ В НЕБО!
	Subtitle.show_text("Maybe hallucinations aren't so bad after all...")
	if camera:
		# Сбрасываем лимиты, которые SeeSharp мог накрутить в инспекторе будки, чтобы они не блокировали полет
		camera.limit_top = -1000000
		camera.limit_bottom = 1000000
		# Отвязываем камеру от игрока, чтобы она летела свободно
		camera.top_level = true
		
		var camera_tween = create_tween()
		# Вычисляем точку высоко в облаках: текущая позиция камеры МИНУС 1500 пикселей вверх по оси Y!
		var target_sky_position = Vector2(self.global_position.x, self.global_position.y - 1500.0)
		
		# Камера пафосно ускоряется и улетает сквозь крышу будки в стратосферу за 3.5 секунды!
		camera_tween.tween_property(camera, "global_position", target_sky_position, 3.5)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_IN_OUT)
	#await Subtitle.text_finished
	#
	#Subtitle.show_text("You chose yourself. Your shift is officially over, Yaroslav.")
	#await Subtitle.text_finished
	#
	# Даем игроку посмотреть на крошечную будку с высоты птичьего полета
	var audio_tween = create_tween()
	audio_tween.tween_property(MusicManager.music_player, "volume_db", -120.0, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	await get_tree().create_timer(2.0).timeout
	
	
	# Мягко гасим экран перед титрами во тьму за 1 секунду
	if ShaderManager.has_method("fade_desaturation"):
		ShaderManager.fade_desaturation(1.0, 1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	# УХОДИМ НА НАШИ ИДЕАЛЬНЫЕ ТИТРЫ С ЦИТАТАМИ И ФЛАГОМ!
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
