extends Node2D

@onready var name_label        = $UI/DialogueBox/NameLabel
@onready var text_label        = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

func _ready():
	# Simple gate: prior charity/trust makes Hider approach; otherwise they avoid.
	if GameState.trust >= 1 or GameState.charity >= 1:
		sit_and_talk()
	else:
		avoid()

func sit_and_talk():
	name_label.text = "Hider"
	text_label.text = "…Can I sit here?"
	clear_choices()

	var share := Button.new()
	share.text = "Share your dilemma sincerely"
	share.pressed.connect(func():
		GameState.trust += 1
		hint()
	)
	choices_container.add_child(share)

	var cold := Button.new()
	cold.text = "Stay distant"
	cold.pressed.connect(end_scene)
	choices_container.add_child(cold)

func hint():
	clear_choices()
	name_label.text = "Hider"
	text_label.text = "You're allowed to say no."
	GameState.trust += 1
	var ok := Button.new()
	ok.text = "Thanks"
	ok.pressed.connect(end_scene)
	choices_container.add_child(ok)

func avoid():
	name_label.text = "Hider"
	text_label.text = "(They avoid you...)"
	clear_choices()
	var ok := Button.new()
	ok.text = "Continue"
	ok.pressed.connect(end_scene)
	choices_container.add_child(ok)

func end_scene():
	get_tree().change_scene_to_file("res://Judgment.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()
