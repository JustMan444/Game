extends Camera3D

@export var target: Node3D
@export var distance: float = 5.0
@export var sensitivity: float = 0.2
@export var min_angle: float = -89.0
@export var max_angle: float = 89.0

var yaw: float = 0.0
var pitch: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_camera()

func _process(delta):
	update_camera()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * sensitivity * 0.01
		pitch -= event.relative.y * sensitivity * 0.01
		pitch = clamp(pitch, deg_to_rad(min_angle), deg_to_rad(max_angle))
		# Поворачиваем игрока по горизонтали
		if target:
			target.rotation.y = yaw

func update_camera():
	if not target:
		return
	var rotation = Quaternion(Vector3.UP, yaw) * Quaternion(Vector3.RIGHT, pitch)
	var direction = rotation * Vector3.FORWARD
	global_transform.origin = target.global_transform.origin + direction * distance
	var up = Vector3.UP
	if abs(pitch) > deg_to_rad(85):
		up = Vector3.FORWARD
	look_at(target.global_transform.origin, up)
