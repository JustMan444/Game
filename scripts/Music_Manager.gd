extends Node
var music_player: AudioStreamPlayer = null

# Твой список треков. Просто дописывай новые файлы через запятую!
var playlist: Array[String] = [
	"res://assets/audio/kevin-macleod-horizon.mp3",
	"res://assets/audio/kevin-macleod-bridge.mp3"
	# "res://audio/track2.mp3",
	# "res://audio/track3.mp3",
]
func _ready():
	_start_background_music()
func _start_background_music():
	if playlist.is_empty():
		print("Музыкальный менеджер: Плейлист пуст, играть нечего!")
		return
		
	music_player = AudioStreamPlayer.new()
	get_tree().root.add_child.call_deferred(music_player)
	
	# Ждём один кадр, чтобы нода встала в дерево
	await get_tree().process_frame
	
	# Автоматическое переключение: когда трек доиграет, сработает следующая случайная песня
	music_player.finished.connect(_play_random_track)
	
	# Запускаем первую песню
	_play_random_track()

func _play_random_track():
	if playlist.is_empty(): return
	
	# 1. Перемешиваем плейлист случайным образом
	playlist.shuffle()
	
	# 2. БЕРЕМ САМЫЙ ПЕРВЫЙ ТРЕК ИЗ ПЕРЕМЕШАННОГО СПИСКА (Исправлено!)
	var random_track_path = playlist[0] 
	var track = load(random_track_path)
	
	if track:
		music_player.stream = track
		
		# НАСТРОЙКА ГРОМКОСТИ (В децибелах. Чем ниже в минус — тем тише!)
		music_player.volume_db = -15.0 
		
		# Отключаем встроенный Loop у трека, чтобы он мог закончиться и вызвать сигнал finished
		if music_player.stream.has_method("set_loop"):
			music_player.stream.loop = false
		elif music_player.stream is AudioStreamMP3:
			music_player.stream.loop = false
		
		music_player.play()
		print("Музыкальный менеджер: Сейчас играет: ", random_track_path)
	else:
		print("Музыкальный менеджер: Не удалось загрузить трек по пути: ", random_track_path)
func play_special_song(audio_path: String):
	# 1. Загружаем новый аудиофайл из папки проекта
	var new_track = load(audio_path)
	if not new_track:
		print("МУЗЫКА: Не удалось найти файл по пути: ", audio_path)
		return
		
	# 2. Создаем Твин для ПЛАВНОГО затухания старой песни за 1.5 секунды
	var tween = create_tween()
	# Узел AudioStreamPlayer внутри менеджера (замени имя '$MusicPlayer', если у тебя другое)
	var player = $MusicPlayer 
	
	# Глушим громкость (volume_db) старого трека в полнейшую тишину (-40 децибел)
	tween.tween_property(player, "volume_db", -40.0, 1.5)
	await tween.finished
	
	# 3. Переключаем трек и возвращаем громкость на нормальный уровень (0 децибел)
	player.stop()
	player.stream = new_track
	player.volume_db = 0.0 # Возвращаем стандартную громкость
	player.play()
	print("МУЗЫКА: Успешно включили специальный финальный трек!")
		
func stop_everything():
	print("МЕНЕДЖЕР МУЗЫКИ: Экстренное глушение Кевина Маклеода...")
	
	# 1. Проверяем, есть ли в самом скрипте переменная-плеер (например, var player или var audio)
	for property in get_property_list():
		var prop_name = property["name"]
		# Ищем любые переменные, внутри которых может лежать звуковой объект
		if prop_name in ["player", "audio", "music_player", "stream_player", "audio_player"]:
			var obj = get(prop_name)
			if obj and obj.has_method("stop"):
				obj.stop()
				print("МЕНЕДЖЕР МУЗЫКИ: Намертво заглушили переменную: ", prop_name)
	
	# 2. На всякий случай жестко гасим все дочерние AudioStreamPlayer, если они там есть
	for child in get_children():
		if child.has_method("stop"):
			child.stop()
			
	print("МЕНЕДЖЕР МУЗЫКИ: Кевин Маклеод официально ушёл со смены!")
