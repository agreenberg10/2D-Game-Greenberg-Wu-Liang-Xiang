extends Node2D

@onready var name_label        = $UI/DialogueBox/NameLabel
@onready var text_label        = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

var lines = [
	{"name":"Girl",        "text":"Would you share your bread?"},
	{"name":"Greedy Man",  "text":"Give it to me. I will make better use of it."},
	{"name":"Player",      "text":"...What should I do?"},
	{"name":"System",      "text":"Your choice will be remembered."}
]

var index := 0

func _ready():
	show_line()

func show_line():
	clear_choices()
	if index < lines.size():
		var L = lines[index]
		name_label.text = L["name"]
		text_label.text = L["text"]
		if L["name"] == "Girl":
			show_choices(["Give bread","Refuse","Let the girl decide"])
	else:
		get_tree().change_scene_to_file("res://CryptoPitch.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()

func show_choices(options:Array):
	for opt in options:
		var btn := Button.new()
		btn.text = opt
		btn.pressed.connect(_on_choice.bind(opt))
		choices_container.add_child(btn)

func _on_choice(choice:String):
	match choice:
		"Give bread":
			GameState.charity += 1
		"Refuse":
			GameState.greed += 1
		"Let the girl decide":
			GameState.charity += 2
			GameState.trust += 1
	index += 1
	show_line()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and choices_container.get_child_count() == 0:
		index += 1
		show_line()
