extends Node3D

@export var sensitivity: float = 0.2
@export var min_pitch: float = -80.0
@export var max_pitch: float = 80.0

var yaw = 0.0
var pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Начальный наклон, чтобы смотреть на игрока сверху
	pitch = deg_to_rad(-15)
	update_rotation()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * sensitivity * 0.01
		pitch -= event.relative.y * sensitivity * 0.01
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		update_rotation()

func update_rotation():
	rotation.y = yaw
	rotation.x = pitch
