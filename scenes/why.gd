extends Area2D

# Вбей сюда в инспекторе координату X, КУДА куб должен приехать (например, 3500)
@export var target_x: float = 3892.0

# Фиксированная скорость куба (600 пикселей в секунду, как у игрока)
@export var speed: float = 601.0

var is_moving: bool = false
var player_node: Node2D = null

func _ready():
	body_entered.connect(_on_body_entered)
	player_node = get_tree().current_scene.find_child("Player2D", true, false)

func _on_body_entered(body: Node):
	if body.name == "Player2D" and not GlobalVars.why:
		GlobalVars.why = true
		_start_scene(body)

func _start_scene(player: Node2D):
	player.set_physics_process(false)
	ShaderManager.fade_insanity(0.1, 1.0)
	
	# Твой диалог
	#Subtitle.show_text("Greetings, traveler. Where are you heading?")
	#await Subtitle.text_finished
	#Subtitle.show_text("Who are you?")
	#await Subtitle.text_finished
	#Subtitle.show_text("Can't you see?")
	#await Subtitle.text_finished
	#Subtitle.show_text("(Maybe because of my colorblindness I can't see him clearly...)")
	#await Subtitle.text_finished
	#Subtitle.show_text("No, no, I see you! I'm just heading home. Where are you going?")
	#await Subtitle.text_finished
	#Subtitle.show_text("I am heading home too. It looks like we're taking the same path, let's walk together.")
	#await Subtitle.text_finished
	#Subtitle.show_text("(Of course I'd rather be alone, but I'd better agree just to be polite.)")
	#await Subtitle.text_finished
	#Subtitle.show_text("Yeah, of course.")
	#await Subtitle.text_finished
	Subtitle.show_text("(This is strange... how does he know that I'm heading home? But whatever.)")
	await Subtitle.text_finished 
	
	player.set_physics_process(true)
	
	# ДИАЛОГ ОКОНЧЕН — ВКЛЮЧАЕМ ЛИНЕЙНЫЙ ХОД В ТОЧКУ!
	is_moving = true

func _process(delta):
	if is_moving:
		# === ПРОВЕРКА НА ВЫБОР ЧАЯ ===
		# Если игрок испугался и побежал НАЗАД к будке (развернулся влево от куба)
		if player_node and player_node.global_position.x < global_position.x:
			print("Куб: Игрок выбрал уютный чай. Растворяюсь...")
			_disappear()
			return
			
		# Плавно двигаем куб строго в сторону target_x со скоростью 600 пикселей в секунду
		global_position.x = move_toward(global_position.x, target_x, speed * delta)
		
		# Если доехали до конечной точки — останавливаемся
		if global_position.x == target_x:
			is_moving = false
			print("Куб: Доехал до конечной точки.")

func _disappear():
	is_moving = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.2)
	tween.tween_callback(func(): queue_free())
