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
