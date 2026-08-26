extends Area2D
@export var sound_player: AudioStreamPlayer2D = null
func interact():
	if GlobalVars.isNeed:
		Subtitle.show_text("(Now is not the time for a shift, even though I'd love to have some tea. It's already late, time to go home.)",0.05,10)
	else:
		Subtitle.show_text("(After all that, it would be a sin not to have some tea and pet the cat. Turned out to be a funny story...)")
		if sound_player:
			sound_player.play()
