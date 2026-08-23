extends ColorRect

var player_health = 100
var player_max_health = 100
var inventory = []
var player_position_2d = Vector2.ZERO
var player_position_3d = Vector3.ZERO
var current_level = "res://scenes/main.tscn"
var coins = 0
var is_transitioning = false
func _ready():
	modulate.a = 0.0
	hide()

func fade_out(duration: float = 0.3):
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	await tween.finished

func fade_in(duration: float = 0.3):
	modulate.a = 1.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	await tween.finished
	hide()

func change_scene(path: String, duration: float = 0.3):
	if is_transitioning:
		return
	is_transitioning = true
	await fade_out(duration)
	get_tree().change_scene_to_file(path)
	await fade_in(duration)
	is_transitioning = false
