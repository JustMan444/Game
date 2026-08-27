extends Area2D

var triggered: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Player2D" and not triggered:
		triggered = true
		GlobalVars.isFinal = true
		_start_invisible_choice()

func _start_invisible_choice():
	var player = get_tree().current_scene.find_child("Player2D", true, false)
	if player:
		player.set_physics_process(false)
	Effects.fade_to()
	Effects.flash()
	Subtitle.show_text("What?!")
	await Subtitle.text_finished
	Subtitle.show_text("What did you say? Is something wrong?")
	await Subtitle.text_finished
	Subtitle.show_text("No, no, everything is fine.")
	await Subtitle.text_finished
	Subtitle.show_text("(Man, I'm being so weird right now! After such a strange day, that actually makes sense. What if I go back?!)")
	await Subtitle.text_finished
	Subtitle.show_text("It’s just that I really dislike weird people because of a certain incident... but whatever.")
	await Subtitle.text_finished
	if player:
		player.set_physics_process(true)
		print("теперь выбор только за игроком")
		
		
