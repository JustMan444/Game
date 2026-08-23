extends Node

# Ссылка на камеру (поддерживает и 2D, и 3D)
var camera: Node = null
var camera_original_pos: Vector3 = Vector3.ZERO
var color_rect: ColorRect = null

func _ready():
	setup_color_rect()

func setup_color_rect():
	color_rect = ColorRect.new()
	color_rect.color = Color.TRANSPARENT
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.anchor_right = 1.0
	color_rect.anchor_bottom = 1.0

	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.add_child(color_rect)
	get_tree().root.add_child.call_deferred(canvas_layer)

# Камера САМА вызывает этот метод в своём скрипте: Effects.register_camera(self)
func register_camera(new_camera: Node):
	camera = new_camera
	if camera is Camera2D or camera is Camera3D:
		camera_original_pos = camera.position
		print("Effects: Камера успешно поймана: ", camera.name)

# --- ЭФФЕКТЫ ---

func shake_camera(intensity: float = 10.0, duration: float = 0.5, step: float = 0.02):
	if not is_instance_valid(camera):
		return

	var timer = 0.0
	while timer < duration:
		if not is_instance_valid(camera):
			break # Защита от удаления камеры посреди цикла

		var offset = Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), 0)
		camera.position = camera_original_pos + offset

		await get_tree().create_timer(step).timeout
		timer += step

	if is_instance_valid(camera):
		camera.position = camera_original_pos

func flash(color: Color = Color.WHITE, duration: float = 0.3):
	# Убрали привязку к камере. Вспышка работает всегда!
	color_rect.color = color
	color_rect.modulate.a = 1.0
	color_rect.show()
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	color_rect.hide()

func fade_to(color: Color = Color.BLACK, duration: float = 0.5, hold: float = 0.0):
	# Убрали привязку к камере. Затемнение работает всегда!
	color_rect.color = color
	color_rect.modulate.a = 0.0
	color_rect.show()
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished
	if hold > 0:
		await get_tree().create_timer(hold).timeout
	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	color_rect.hide()

func slow_mo(factor: float = 0.2, duration: float = 2.0):
	Engine.time_scale = factor
	await get_tree().create_timer(duration * factor).timeout
	Engine.time_scale = 1.0

func stop_all():
	Engine.time_scale = 1.0
	if is_instance_valid(camera):
		camera.position = camera_original_pos
	color_rect.hide()
	color_rect.modulate.a = 0.0
