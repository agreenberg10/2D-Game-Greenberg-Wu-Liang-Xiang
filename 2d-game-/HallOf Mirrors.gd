extends Node2D

@onready var name_label        = $UI/DialogueBox/NameLabel
@onready var text_label        = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

func _ready():
	name_label.text = "Memory"
	text_label.text = "What dilemma brought you here? Choose one."
	show_paths()

func show_paths():
	clear_choices()
	var options = [
		"A: Corporate fraud — blow the whistle or stay silent",
		"B: Surgery consent — ethically fraught decision",
        "C: High-interest loan — relieve yourself but harm another"
	]
	for o in options:
		var btn := Button.new()
		btn.text = o
		btn.pressed.connect(_on_path_chosen.bind(o))
		choices_container.add_child(btn)

func _on_path_chosen(option:String):
	clear_choices()
	text_label.text = "Write one sentence: Why did you board this train?"
	var input := LineEdit.new()
	choices_container.add_child(input)

	var confirm := Button.new()
	confirm.text = "Confirm"
	confirm.pressed.connect(func():
		var msg := input.text.strip_edges()
		if msg == "":
			msg = "(silent)"
		ProjectSettings.set_setting("user/why_line", msg)
		get_tree().change_scene_to_file("res://HiderScene.tscn")
	)
	choices_container.add_child(confirm)

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()
