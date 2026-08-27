extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Player2D" and not GlobalVars.whyr:
		GlobalVars.whyr = true
		Subtitle.show_text("(Maybe I should go back to my shift? But yeah, that would be rude... and it would probably look weird if I worked two shifts in a row.)")
