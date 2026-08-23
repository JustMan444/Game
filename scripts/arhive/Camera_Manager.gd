extends Node3D

@export var camera_first: Camera3D
@export var camera_third: Camera3D
@export var player: CharacterBody3D
@export var head: Node3D
@export var mesh_to_hide: NodePath
@export var camera_pivot: Node3D

var is_first_person = false
var yaw = 0.0
var pitch_fps = 0.0
var pitch_tps = 0.0
var sensitivity = 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if camera_third:
		camera_third.make_current()
	if camera_first:
		camera_first.current = false
	if player:
		yaw = player.rotation.y

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		toggle_camera()
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * sensitivity * 0.01
		
		if is_first_person:
			pitch_fps -= event.relative.y * sensitivity * 0.01
			pitch_fps = clamp(pitch_fps, -80.0, 80.0)
			if player:
				player.rotation.y = yaw
			if head:
				head.rotation.x = deg_to_rad(pitch_fps)
		else:
			pitch_tps -= event.relative.y * sensitivity * 0.01
			pitch_tps = clamp(pitch_tps, -30.0, 30.0)
			if player:
				player.rotation.y = yaw
			if camera_pivot:
				camera_pivot.rotation.x = deg_to_rad(pitch_tps)
			if head:
				head.rotation.x = 0

func toggle_camera():
	is_first_person = !is_first_person
	if is_first_person:
		if camera_third:
			camera_third.current = false
		if camera_first:
			camera_first.make_current()
		if mesh_to_hide and has_node(mesh_to_hide):
			get_node(mesh_to_hide).hide()
		if head:
			head.rotation.x = deg_to_rad(pitch_fps)
	else:
		if camera_first:
			camera_first.current = false
		if camera_third:
			camera_third.make_current()
		if mesh_to_hide and has_node(mesh_to_hide):
			get_node(mesh_to_hide).show()
		if head:
			head.rotation.x = 0
		if camera_pivot:
			camera_pivot.rotation.x = deg_to_rad(pitch_tps)
