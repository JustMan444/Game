extends Area2D

var choice_made: bool = false
var waiting_for_choice: bool = false

func interact():
	# 1. Если выбор УЖЕ был сделан раньше, бомж просто повторяет финальную реплику
	if choice_made:
		if GlobalVars.helped_homeless:
			Subtitle.show_text("Thank you so much for your help, but I no longer have any need for money.'")
		else:
			Subtitle.show_text("Ah, spare a coin, good people, for Christ’s sake... my days are heavy and my soul is so weary of this life.")
			ShaderManager.fade_desaturation(1.3,400)
		return
		
	# Защита от спама кнопкой E: если диалог идёт, повторные нажатия игнорируются
	if waiting_for_choice: return
	waiting_for_choice = true
	
	# 2. Включаем стартовую реплику встречи через твой глобальный синглтон
	Subtitle.show_text("Greetings, comrade traveler. Please, let an old man into the scrapyard, I just need to gather some empty bottles for kopecks. Twenty years ago, my family home burned to ashes—documents, savings, everything perished.")
	await Subtitle.text_finished
	Subtitle.show_text("Who has any use for a broken Soviet old-timer now?")
	await Subtitle.text_finished
	Subtitle.show_text("They will give me sixty kopecks for the glass. Just enough for a loaf of black bread and a little cheese, so this old body doesn't drop dead from hunger.")
	# Ждём твой честный сигнал об окончании печати текста от Subtitle!

	await Subtitle.text_finished
	# Текст гарантированно дописался — автоматически выводим плашку выбора
	_show_choice_options()

func _show_choice_options():
	Subtitle.show_text("[Press 1] Give 20 dollars   [Press 2] Walk away  [Press 3] Drive him away")

func _input(event):
	# Слушаем клавиатуру строго в режиме ожидания выбора
	if not waiting_for_choice or choice_made or event is not InputEventKey or not event.is_pressed(): 
		return
		
	# ВЫБОР 1: Помочь бомжу
	if event.keycode == KEY_1:
		choice_made = true
		waiting_for_choice = false
		
		GlobalVars.helped_homeless = true
		Subtitle.stop() # Срочно гасим плашку выбора, чтобы текст не накладывался!
		Subtitle.show_text("Here, let me give you 20 dollars. I know it won't fix everything, but hang in there, old man!")
		await Subtitle.text_finished
		Subtitle.show_text("Thank you. I will remember this.")
		# Эффект страха: экран плавно и красиво багровеет без ошибок благодаря твоему методу!
		ShaderManager.fade_insanity(0.0, 0.5)
		
	# ВЫБОР 2: Пройти мимо
	elif event.keycode == KEY_2:
		choice_made = true
		waiting_for_choice = false
		Subtitle.stop() 
		GlobalVars.helped_homeless = false
		Subtitle.stop() # Срочно гасим плашку выбора
		Subtitle.show_text("...")
		ShaderManager.fade_insanity(0.4, 0.5)
	elif event.keycode == KEY_3:
		Subtitle.stop()
		Subtitle.show_text("Ah, have mercy, Comrade Sergeant! Let me go, I am just a simple Soviet hobo. I have done no harm to a single soul, I swear to you.")
		GlobalVars.helped_homeless = false
		choice_made = true
		waiting_for_choice = false
		ShaderManager.fade_insanity(0.8, 30.3)
		
