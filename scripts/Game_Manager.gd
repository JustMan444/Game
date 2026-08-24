extends Node

# Данные для перехода между измерениями
var player_position_2d = Vector2.ZERO
var player_position_3d = Vector3.ZERO
var current_dimension = "2d"

# Инвентарь, здоровье, квесты
var inventory = []
var player_health = 100
var quest_flags = {}

# Флаг, чтобы избежать повторных переходов во время анимации
var is_transitioning = false

# Универсальная функция смены сцены с затемнением
func switch_to_scene(path: String, fade_color: Color = Color.BLACK, fade_duration: float = 0.5):
	if is_transitioning:
		return
	is_transitioning = true

	# Затемняем экран
	await Effects.fade_to(fade_color, fade_duration, 0.0)

	# Меняем сцену
	get_tree().change_scene_to_file(path)

	# Постепенно появляемся
	await Effects.fade_to(fade_color, fade_duration, 0.0)  # второй раз fade_to делает появление

	is_transitioning = false

# Переключение на 3D (сохраняет позицию игрока 2D)
func switch_to_3d(player_2d_node: Node2D):
	player_position_2d = player_2d_node.position
	current_dimension = "3d"
	switch_to_scene("res://scenes/3d_level.tscn")
	#get_tree().call_deferred("change_scene_to_file", path)

# Переключение на 2D (сохраняет позицию игрока 3D)
func switch_to_2d(player_3d_node: Node3D):
	player_position_3d = player_3d_node.position
	current_dimension = "2d"
	switch_to_scene("res://scenes/2d_level.tscn")
	#get_tree().call_deferred("change_scene_to_file", path)
