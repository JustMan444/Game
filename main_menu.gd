extends Control

@onready var play_button = $VBoxContainer/PlayButton

func _ready():
	get_tree().paused = false
	AudioServer.set_bus_mute(0, false)
	var menu_audio = AudioStreamPlayer.new()
	add_child(menu_audio)
	menu_audio.stream = load("res://assets/audio/bad song.mp3") # Путь к его треку!
	if menu_audio.stream:
		menu_audio.volume_db = -60.0 # Чуть приглушим, чтобы по ушам не било
		
		menu_audio.play()
		var audio_tween = create_tween()
		audio_tween.tween_property(menu_audio, "volume_db", -12.0, 5.0)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		print("ГЛАВНОЕ МЕНЮ: Запущен трек SeeSharp!")
	# Подключаем сигналы
	if play_button:
		play_button.pressed.connect(_on_play_button_pressed)
		
		
	# ОТЛОЖЕННЫЙ СБРОС МЫШКИ: Освобождаем курсор на следующий кадр,
	# чтобы Godot 4 не сожрал первый клик после захвата!
	call_deferred("_release_mouse_focus")

func _release_mouse_focus():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Принудительно заставляем саму кнопку PLAY принимать фокус мыши
	if play_button:
		play_button.grab_focus()
	
	print("ГЛАВНОЕ МЕНЮ: Фокус мыши принудительно очищен и готов к первому клику!")


func _on_play_button_pressed():
	print("ГЛАВНОЕ МЕНЮ: Старт игры! Загрузка улицы...")
	# Обязательно сбрасываем флаг финала перед новым прохождением!
	GlobalVars.isFinal = false
	MusicManager._start_background_music()
	GlobalVars.helped_homeless = false
	# ИСПРАВЛЕНО: Укажи точный путь к сцене твоей улицы в кавычках!
	GameManager.switch_to_scene("res://scenes/будка_охраны.tscn")
