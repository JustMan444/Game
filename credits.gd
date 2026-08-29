extends Control

@onready var credits_text = $ColorRect/CreditsText

func _ready():
	#MusicManager.stop_everything()
	MusicManager.play_special_song("res://assets/audio/Ray_Parker_-_Ghostbusters_OST_Okhotniki_za_privedeniyami_28528277.mp3")
	MusicManager.final_volume_db = -100
	var audio_tween = create_tween()
	audio_tween.tween_property(MusicManager.music_player, "volume_db", -10.0, 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	#MusicManager.stop_everything()
	#var final_audio_player = AudioStreamPlayer.new()
	#add_child(final_audio_player)
	#
	## ЗАМЕНИ ПУТЬ НИЖЕ: Вставь точное имя и путь к своей специальной песне!
	#final_audio_player.stream = load("res://assets/audio/Ray_Parker_-_Ghostbusters_OST_Okhotniki_za_privedeniyami_28528277.mp3") 
	#
	#if final_audio_player.stream:
		#final_audio_player.volume_db = 0.0 # Громкость на полную
		#final_audio_player.play()
		#print("ТИТРЫ: Финальный трек успешно запущен автономно прямо на сцене!")
	#else:
		#print("ТИТРЫ: Ошибка! Звуковой файл не найден по указанному пути.")
		#
	## 1. ВКЛЮЧАЕМ АВТО-ВЫСОТУ: Заставляем ноду расти вниз без ограничений под твой длинный текст!
	if credits_text is Label:
		credits_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	elif credits_text is RichTextLabel:
		credits_text.fit_content = true
		
	# Отключаем конфликты интерфейса Godot
	credits_text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_WIDTH)
	credits_text.grow_horizontal = Control.GROW_DIRECTION_BOTH
	credits_text.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# Прячем текст в самый низ экрана перед стартом
	credits_text.position.y = get_viewport().get_visible_rect().size.y + 370
	
	# Твой легендарный список авторов буква в букву:
	credits_text.text = """
	
	SHIFT IS OVER
	
	
	
	--- CREW ---
	
	Lead Programmer / Director:
	Just_Man444
	
	Lead Narrative Designer / Writer:
	sssaden
	
	Level Design / Art:
	Just_Man444
	mosh_
	
	Management / Moral Support / Music in main menu:
	SeeSharp
	
	
	
	--- SPECIAL THANKS ---
	
	To the Brackeys Game Jam 2026 organizers.
	To everyone who supported us through sleepless nights.
	To You, The Player.
	
	And...
	To the 2D Cube that chased us at a speed of 601.0 pixels.
	
	
	--- Quotes from the crew ---
	
	"This game was amazingly fun to make" 
	- (SeeSharp)
	
	"Thank you for playing! Have you unlocked all the endings? 🇷🇺" 
	— (Just_Man444)
	
	"Don't try this at home."
	- (sssaden)
	
	To be continued...
	
		
	--- END OF THE SHIFT ---
	
	Thank you for playing!
	
	"""
	
	# Запускаем полёт титров вверх!
	_start_credits_scroll()

func _start_credits_scroll():
	# 2. ДИНАМИЧЕСКИЙ РАСЧЕТ: Считаем реальный размер огромного текста, чтобы Твин знал точный конец!
	var text_height = credits_text.get_combined_minimum_size().y
	if text_height < 1000.0:
		text_height = 3500.0 # Страховочный запас, если движок выдаст ноль
		
	var target_y = -text_height - 200.0
	
	var tween = create_tween()
	
	# Плавная скорость хода: 18 секунд, чтобы игроки успели с кайфом дочитать твои цитаты!
	tween.tween_property(credits_text, "position:y", target_y, 80.0).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	
	print("ТИТРЫ ОКОНЧЕНЫ. Возврат в главное меню.")
	get_tree().change_scene_to_file("res://main_menu.tscn")
