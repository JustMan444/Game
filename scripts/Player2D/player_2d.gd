extends CharacterBody2D

# Движение
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 980.0

# Взаимодействие
var nearby_object = null
var can_interact = false

var was_in_air = false
var camera_bounce_tween = null

@onready var hint_label = $HintLabel

func _ready():
	if hint_label:
		hint_label.hide()

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_key_pressed(KEY_R): 
		GameManager.switch_to_scene("res://scenes/world.tscn")
	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Горизонтальное движение
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# Взаимодействие
	if Input.is_action_just_pressed("interact") and can_interact and nearby_object:
		if nearby_object.has_method("interact"):
			nearby_object.interact()

	# Эффект приземления
	if was_in_air and is_on_floor():
		bounce_camera()
	was_in_air = not is_on_floor()

func _on_InteractZone_body_entered(body):
	if body.has_method("interact"):
		nearby_object = body
		can_interact = true
		if hint_label:
			hint_label.text = "Нажмите E"
			hint_label.show()

func _on_InteractZone_body_exited(body):
	if body == nearby_object:
		nearby_object = null
		can_interact = false
		if hint_label:
			hint_label.hide()

func bounce_camera():
	var cam = get_viewport().get_camera_2d()
	if not cam:
		return
	if camera_bounce_tween and camera_bounce_tween.is_valid():
		camera_bounce_tween.kill()
	camera_bounce_tween = create_tween()
	var original = cam.position
	var target_down = original + Vector2(0, 3)
	camera_bounce_tween.tween_property(cam, "position", target_down, 0.05)
	camera_bounce_tween.tween_property(cam, "position", original, 0.1)
