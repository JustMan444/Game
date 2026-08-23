extends Node3D

@export var player: CharacterBody3D
@export var camera_first: Camera3D
@export var camera_third: Camera3D
@export var camera_pivot: Node3D
@export var mesh_to_hide: NodePath

var is_first_person = false

func _ready():
	if camera_third:
		camera_third.make_current()
	if camera_first:
		camera_first.current = false
	# Включаем обработку ввода для пивота
	if camera_pivot:
		camera_pivot.set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		toggle_camera()

func toggle_camera():
	is_first_person = !is_first_person
	if is_first_person:
		if camera_third:
			camera_third.current = false
		if camera_first:
			camera_first.make_current()
		if mesh_to_hide and has_node(mesh_to_hide):
			get_node(mesh_to_hide).hide()
		# Отключаем вращение пивота, чтобы мышь не двигала камеру в FPS
		if camera_pivot:
			camera_pivot.set_process_input(false)
	else:
		if camera_first:
			camera_first.current = false
		if camera_third:
			camera_third.make_current()
		if mesh_to_hide and has_node(mesh_to_hide):
			get_node(mesh_to_hide).show()
		# Включаем вращение пивота
		if camera_pivot:
			camera_pivot.set_process_input(true)
		# Сбрасываем голову (чтобы не было криво)
		var head = player.get_node("Head")
		if head:
			head.rotation.x = 0
