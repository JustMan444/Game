extends Node

var current_language = "en"
var dialogues = {}

func _ready():
	load_dialogues("res://data/dialogues.json")

func load_dialogues(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		dialogues = JSON.parse_string(content)
		if dialogues == null:
			print("Ошибка парсинга JSON: ", path)
	else:
		print("Файл не найден: ", path)

func get_dialogue(id: String, language: String = ""):
	if language == "":
		language = current_language
	if dialogues.has(language) and dialogues[language].has(id):
		return dialogues[language][id]
	else:
		if language != "en" and dialogues.has("en") and dialogues["en"].has(id):
			return dialogues["en"][id]
		else:
			print("Диалог не найден: ", id, " на языке ", language)
			return {"speaker": "?", "text": "[DIALOG MISSING]"}

func set_language(lang: String):
	if dialogues.has(lang):
		current_language = lang
	else:
		print("Язык не поддерживается: ", lang)

func get_speaker(id: String, language: String = "") -> String:
	var diag = get_dialogue(id, language)
	return diag.get("speaker", "?")

func get_text(id: String, language: String = "") -> String:
	var diag = get_dialogue(id, language)
	return diag.get("text", "[DIALOG MISSING]")
