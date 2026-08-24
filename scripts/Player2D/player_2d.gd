extends CharacterBody2D

# Движение
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 980.0  # стандартная гравитация

# Взаимодействие
var nearby_object = null
var can_interact = false

@onready var hint_label = $HintLabel  # Label для подсказки "Нажмите E"

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta

	# Прыжок (отдельная кнопка, например, Space)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Горизонтальное движение
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# Взаимодействие (кнопка E)
	if Input.is_action_just_pressed("interact") and can_interact and nearby_object:
		if nearby_object.has_method("interact"):
			nearby_object.interact()

# Сигналы от зонда (подключаются в редакторе)
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
