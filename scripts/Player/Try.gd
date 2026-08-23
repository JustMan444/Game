extends Camera3D

@export var player: CharacterBody3D
@export var sensitivity: float = 0.2
@export var min_pitch: float = -80.0
@export var max_pitch: float = 80.0

var pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Поворачиваем игрока по горизонтали (ось Y)
		player.rotation.y -= event.relative.x * sensitivity * 0.01
		
		# Наклоняем камеру по вертикали (ось X)
		pitch -= event.relative.y * sensitivity * 0.01
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		rotation.x = pitch
