extends Node

@export var final_volume_db: float = -10.0 
var music_player: AudioStreamPlayer = null
var playlist: Array[String] = [
	"res://assets/audio/kevin-macleod-horizon.mp3",
    "res://assets/audio/kevin-macleod-bridge.mp3"
]
var is_final_credits: bool = false

func _ready():
	if is_final_credits:
		return
	_start_background_music()

func _start_background_music():
	if playlist.is_empty():
		print("Музыкальный менеджер: Плейлист пуст, играть нечего!")
		return

	music_player = AudioStreamPlayer.new()
	get_tree().root.add_child.call_deferred(music_player)
	await get_tree().process_frame

	music_player.finished.connect(_play_random_track)
	_play_random_track()

func _play_random_track():
	if is_final_credits:
		return
	if playlist.is_empty():
		return

	playlist.shuffle()
	var random_track_path = playlist[0]
	var track = load(random_track_path)

	if track:
		music_player.stream = track
		music_player.volume_db = -17.0

		if music_player.stream.has_method("set_loop"):
			music_player.stream.set_loop(false)
		elif music_player.stream.has_property("loop"):
			music_player.stream.loop = false

		music_player.play()
		print("Музыкальный менеджер: Сейчас играет: ", random_track_path)
	else:
		print("Музыкальный менеджер: Не удалось загрузить трек: ", random_track_path)

func play_special_song(audio_path: String):
	is_final_credits = true
	print("Музыкальный менеджер: Запрос на специальный финал...")

	var new_track = load(audio_path)
	if not new_track:
		print("Музыкальный менеджер: Ошибка! Не нашли песню по пути: ", audio_path)
		return

	if not music_player:
		music_player = AudioStreamPlayer.new()
		get_tree().root.add_child.call_deferred(music_player)
		await get_tree().process_frame

	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40.0, 1.0)
		await tween.finished

	music_player.stop()
	music_player.stream = new_track
	music_player.volume_db = final_volume_db
	music_player.call_deferred("play")
	print("Музыкальный менеджер: Сейчас играет (ФИНАЛ): ", audio_path)

func stop_everything():
	if music_player:
		music_player.stop()
		print("Музыкальный менеджер: Кевин Маклеод ушёл со смены!")

func pause():
	if music_player and music_player.playing:
		music_player.stop()

func resume():
	if music_player and music_player.stream:
		music_player.play()
