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
	if Input.is_key_pressed(KEY_F):
		print("TEST")
		#TextManager.show_text("Этот текст будет печататься медленно", 0.5, 10.0)
		#TextManager.show_text("ffffff")
		Subtitle.show_text("Its text for dialog its just test",0.1,15)
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
#func _process(_delta):
	## Ультимативный поиск коллизий без сигналов прямо каждый кадр!
	#_check_interaction_direct()

#func _check_interaction_direct():
	#if not has_node("InteractZone"): return
	#
	## Берем список ВЕХ зон, которые сейчас физически пересекают наш "щуп"
	#var overlapping_areas = $InteractZone.get_overlapping_areas()
	#
	#var found_object = null
	#for area in overlapping_areas:
		#if area.has_method("interact"):
			#found_object = area
			#break # Нашли первый попавшийся интерактивный объект — берём его
			#
	#if found_object:
		#nearby_object = found_object
		#can_interact = true
		#if hint_label:
			#hint_label.text = "Нажмите E"
			#hint_label.show()
	#else:
		## Если под ногами ничего нет — сбрасываем
		#nearby_object = null
		#can_interact = false
		#if hint_label:
			#hint_label.hide()

## === 1. РАБОТА С ФИЗИЧЕСКИМИ ТЕЛАМИ (StaticBody2D, CharacterBody2D) ===
#func _on_InteractZone_body_entered(body):
	#if body != self and body.has_method("interact"):
		#nearby_object = body
		#can_interact = true
		#if hint_label:
			#hint_label.text = "Нажмите E"
			#hint_label.show()
#
#func _on_InteractZone_body_exited(body):
	#if body == nearby_object:
		#_reset_interaction()
#
## === 2. РАБОТА С ЗОНАМИ (Area2D) ===
#func _on_InteractZone_area_entered(area):
	#if area.has_method("interact"):
		#nearby_object = area
		#can_interact = true
		#if hint_label:
			#hint_label.text = "Нажмите E"
			#hint_label.show()
#
#func _on_InteractZone_area_exited(area):
	#if area == nearby_object:
		#_reset_interaction()
#
## Микро-функция сброса, чтобы не дублировать код
#func _reset_interaction():
	#nearby_object = null
	#can_interact = false
	#if hint_label:
		#hint_label.hide()

# === 1. РАБОТА С ФИЗИЧЕСКИМИ ТЕЛАМИ (StaticBody2D, CharacterBody2D) ===
func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body != self and body.has_method("interact"):
		nearby_object = body
		can_interact = true
		if hint_label:
			hint_label.text = "Нажмите E"
			hint_label.show()

func _on_interact_zone_body_exited(body: Node2D) -> void:
	if body == nearby_object:
		_reset_interaction()

# === 2. РАБОТА С ЗОНАМИ (Area2D - касса, бомж, перец) ===
func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area.has_method("interact"):
		nearby_object = area
		can_interact = true
		if hint_label:
			hint_label.text = "Нажмите E"
			TextManager.show_text("Этот текст будет печататься медленно", 0.5, 50.0)
			hint_label.show()

func _on_interact_zone_area_exited(area: Area2D) -> void:
	if area == nearby_object:
		_reset_interaction()

# Универсальная функция сброса
func _reset_interaction() -> void:
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
