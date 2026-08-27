extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Player2D" and not GlobalVars.why:
		GlobalVars.why = true
		ShaderManager.fade_insanity(0.1, 1.0)
#ShaderManager.fade_desaturation(0.2,4)
		Subtitle.show_text("Greetings, traveler. Where are you heading?")
		await Subtitle.text_finished
		Subtitle.show_text("Who are you?")
		await Subtitle.text_finished
		Subtitle.show_text("Can't you see?")
		await Subtitle.text_finished
		Subtitle.show_text("(Maybe because of my colorblindness I can't see him clearly... he'll think I'm completely insane.)")
		await Subtitle.text_finished
		Subtitle.show_text("No, no, I see you! I'm just heading home. Where are you going?")
		await Subtitle.text_finished
		Subtitle.show_text("I am heading home too. It looks like we're taking the same path, let's walk together.")
		await Subtitle.text_finished
		Subtitle.show_text("(Of course I'd rather be alone after all the fucked-up shit that happened to me today, but I'd better agree just to be polite.)")
		await Subtitle.text_finished
		Subtitle.show_text("Yeah, of course.")
		await Subtitle.text_finished
		Subtitle.show_text("(This is strange... how does he know that I'm heading home? But whatever.)")
