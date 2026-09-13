extends Control

signal anim_finished(anim_name : String)

signal go_to_game()
signal go_to_options()
signal go_to_credits()

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var language_selector : OptionButton = $Margin/LanguageSelector

func _ready() -> void:
	_setup_language_selector()
	Localization.language_changed.connect(_on_localization_language_changed)

func _setup_language_selector() -> void:
	language_selector.clear()
	var available_langs = Localization.get_available_languages()
	for lang in available_langs:
		language_selector.add_item(Localization.get_language_display_name(lang), hash(lang))
	
	# Set current language as selected
	var current_index = 0
	for i in range(language_selector.item_count):
		if hash(Localization.get_available_languages()[i]) == language_selector.get_item_id(i):
			current_index = i
			break
	language_selector.select(current_index)

func _on_language_selected(index: int) -> void:
	var available_langs = Localization.get_available_languages()
	if index >= 0 and index < available_langs.size():
		Localization.set_language(available_langs[index])

func _on_localization_language_changed(new_lang: String) -> void:
	# Update language selector to reflect the new language
	_setup_language_selector()

func _on_start_pressed() -> void:
	go_to_game.emit()
	
func _on_options_pressed() -> void:
	go_to_options.emit()
	
func _on_credits_pressed() -> void:
	go_to_credits.emit()
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func fade_in() -> void:
	animation_player.play("FadeIn")
	
func fade_out() -> void:
	animation_player.play("FadeOut")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit(anim_name)
