extends Node

var canvas: CanvasLayer = null
var shader_rect: ColorRect = null
var _initialized: bool = false

func _ready():
	# Инициализируем фильтр автоматически при старте игры
	_initialize_filter()

func _initialize_filter():
	if _initialized:
		return
		
	# Создаём CanvasLayer поверх всей игры (и 2D, и 3D)
	canvas = CanvasLayer.new()
	canvas.layer = 9 # Чуть ниже текста субтитров (у него 10), чтобы текст не окрашивался в красный
	get_tree().root.add_child.call_deferred(canvas)
	
	# Ждём один кадр, чтобы Godot создал слой
	await get_tree().process_frame
	
	# Создаём полноэкранный ColorRect
	shader_rect = ColorRect.new()
	shader_rect.name = "RetroHorrorFilter"
	
	# Намертво растягиваем на весь экран (адаптивная верстка)
	shader_rect.anchor_left = 0.0
	shader_rect.anchor_right = 1.0
	shader_rect.anchor_top = 0.0
	shader_rect.anchor_bottom = 1.0
	shader_rect.offset_left = 0
	shader_rect.offset_right = 0
	shader_rect.offset_top = 0
	shader_rect.offset_bottom = 0
	
	# Игнорируем мышь, чтобы не ломать клики и управление в 3D
	shader_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Загружаем наш файл шейдера
	var shader_file = load("res://sheiders/retro_horror.gdshader")
	if shader_file:
		var mat = ShaderMaterial.new()
		mat.shader = shader_file
		shader_rect.material = mat
		print("ShaderManager: Ретро-хоррор фильтр успешно запущен!")
	else:
		print("ShaderManager: КРИТИЧЕСКАЯ ОШИБКА! Шейдер по пути res://sheiders/retro_horror.gdshader не найден!")
		
	canvas.add_child(shader_rect)
	_initialized = true

# --- УПРАВЛЕНИЕ ЭФФЕКТАМИ ИЗ ЛЮБОГО СКРИПТА ---

# Плавно изменить уровень серости (1.0 — полный чб, 0.0 — цветная игра)
func fade_desaturation_a(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var tween = create_tween()
	tween.tween_property(shader_rect.material, "shader_parameter/desaturation_level", target_value, duration)

# Плавно включить/выключить красное безумие (1.0 — кровавый экран, 0.0 — обычный чб)
func fade_insanity_a(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var tween = create_tween()
	tween.tween_property(shader_rect.material, "shader_parameter/insanity_level", target_value, duration)

# Плавно изменить силу шума плёнки
func fade_grain_a(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var tween = create_tween()
	tween.tween_property(shader_rect.material, "shader_parameter/grain_amount", target_value, duration)
# Плавно изменить уровень серости
# Плавно изменить уровень серости
# Плавно изменить уровень серости
func fade_desaturation(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var mat = shader_rect.material
	var current_val = mat.get_shader_parameter("desaturation_level")
	
	# ЗАЩИТА ОТ NIL: если значение пустое, принудительно ставим дефолт 1.0 (полный чб)
	if current_val == null:
		current_val = 1.0
	
	var tween = create_tween()
	tween.tween_method(
		func(val): mat.set_shader_parameter("desaturation_level", val),
		current_val, target_value, duration
	)

# Плавно включить/выключить красное безумие
func fade_insanity(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var mat = shader_rect.material
	var current_val = mat.get_shader_parameter("insanity_level")
	
	# ЗАЩИТА ОТ NIL: если значение пустое, ставим стартовый ноль
	if current_val == null:
		current_val = 0.0
	
	var tween = create_tween()
	tween.tween_method(
		func(val): mat.set_shader_parameter("insanity_level", val),
		current_val, target_value, duration
	)

# Плавно изменить силу шума плёнки
func fade_grain(target_value: float, duration: float = 1.0):
	if not shader_rect or not shader_rect.material: return
	var mat = shader_rect.material
	var current_val = mat.get_shader_parameter("grain_amount")
	
	# ЗАЩИТА ОТ NIL: если значение пустое, ставим базовый шум 0.05
	if current_val == null:
		current_val = 0.05
	
	var tween = create_tween()
	tween.tween_method(
		func(val): mat.set_shader_parameter("grain_amount", val),
		current_val, target_value, duration
	)
