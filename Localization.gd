extends Node
signal language_changed(new_lang: String)

var current_lang := "pt"
var translations := {
	"pt": {
		"Começar": "Começar",
		"Opções": "Opções",
		"Créditos": "Créditos",
		"Sair": "Sair",
		"Versão 1.1": "Versão 1.1",
		"PaNik": "PaNik",
		"Start": "Começar",
		"Options": "Opções",
		"Credits": "Créditos",
		"Exit": "Sair",
		"Version": "Versão",
		"Language": "Idioma",
		"Portuguese": "Português",
		"Chinese": "中文",
		"Back": "Voltar",
		"Master Volume": "Volume Mestre",
		"SFX Volume": "Volume Efeitos",
		"Music Volume": "Volume Música",
		"Brightness": "Brilho",
		"Difficulty": "Dificuldade",
		"Easy": "Fácil",
		"Normal": "Normal",
		"Hard": "Difícil",
		"Controls": "Controles",
		"Reset to Default": "Restaurar Padrão",
		"Apply": "Aplicar",
	},
	"zh": {
		"Começar": "开始游戏",
		"Opções": "选项",
		"Créditos": "制作人员",
		"Sair": "退出",
		"Versão 1.1": "版本 1.1",
		"PaNik": "PaNik",
		"Start": "开始游戏",
		"Options": "选项",
		"Credits": "制作人员",
		"Exit": "退出",
		"Version": "版本",
		"Language": "语言",
		"Portuguese": "葡萄牙语",
		"Chinese": "中文",
		"Back": "返回",
		"Master Volume": "主音量",
		"SFX Volume": "音效音量",
		"Music Volume": "音乐音量",
		"Brightness": "亮度",
		"Difficulty": "难度",
		"Easy": "简单",
		"Normal": "普通",
		"Hard": "困难",
		"Controls": "控制",
		"Reset to Default": "恢复默认",
		"Apply": "应用",
	}
}

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		current_lang = cfg.get_value("general", "language", "pt")
	else:
		current_lang = "pt"
	apply_language(current_lang)

func t(orig: String) -> String:
	if current_lang in translations and translations[current_lang].has(orig):
		return translations[current_lang][orig]
	return orig

func set_language(lang: String) -> void:
	if current_lang == lang:
		return
	current_lang = lang
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value("general", "language", lang)
	cfg.save("user://settings.cfg")
	apply_language(lang)
	emit_signal("language_changed", lang)

func apply_language(lang: String) -> void:
	_apply_node_recursive(get_tree().get_root())

func _apply_node_recursive(node: Node) -> void:
	for child in node.get_children():
		_apply_node_recursive(child)
		# OptionButton: translate each item, but keep original items in meta so we can revert
		if child is OptionButton:
			if not child.has_meta("orig_items"):
				var items := []
				for i in range(child.get_item_count()):
					items.append(child.get_item_text(i))
				child.set_meta("orig_items", items)
			child.clear()
			for item in child.get_meta("orig_items"):
				child.add_item(t(item))
		# Labels/Buttons/RichTextLabel/LineEdit: store original text and translate
		elif child is Label or child is Button or child is RichTextLabel or child is LineEdit:
			if not child.has_meta("orig_text"):
				child.set_meta("orig_text", child.text)
			var orig := child.get_meta("orig_text")
			child.text = t(orig)

func get_available_languages() -> Array:
	return translations.keys()

func get_language_display_name(lang: String) -> String:
	match lang:
		"pt":
			return t("Portuguese")
		"zh":
			return t("Chinese")
		_:
			return lang
