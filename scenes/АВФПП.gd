extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Player2D" and not GlobalVars.bug_portal_used1:
		GlobalVars.bug_portal_used1 = true
		ShaderManager.fade_insanity(0.5, 1.0)
		ShaderManager.fade_desaturation(2,4)
		GlobalVars.player_street_position = body.global_position
		GameManager.switch_to_scene("res://bug1.tscn", Color.DIM_GRAY, 0.001)
