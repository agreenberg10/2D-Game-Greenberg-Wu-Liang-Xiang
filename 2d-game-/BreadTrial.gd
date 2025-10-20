extends Node2D

@onready var name_label = $UI/DialogueBox/NameLabel
@onready var text_label = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

var dialogue = []
var current_line = 0

func _ready():
	load_dialogue()
	show_line()

func load_dialogue():
	dialogue = [
		{"name":"Girl", "text":"Would you share your bread?"},
		{"name":"GreedyMan", "text":"We must invest it wisely!"},
		{"name":"Player", "text":"...What should I do?"}
	]

func show_line():
	if current_line < dialogue.size():
		var line = dialogue[current_line]
		name_label.text = line["name"]
		text_label.text = line["text"]
		clear_choices()

		# Show choices only when Girl speaks
		if line["name"] == "Girl":
			show_choices(["Give bread","Refuse","Let the girl decide"])
	else:
		# After dialogue, move to next scene
		get_tree().change_scene_to_file("res://CryptoPitch.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()

func show_choices(options:Array):
	for opt in options:
		var btn = Button.new()
		btn.text = opt
		btn.connect("pressed", Callable(self, "_on_choice_pressed").bind(opt))
		choices_container.add_child(btn)

func _on_choice_pressed(choice):
	match choice:
		"Give bread":
			print("You gave bread → Charity +1")
		"Refuse":
			print("You refused → Greed +1")
		"Let the girl decide":
			print("You respected choice → Trust +1")
	next_line()

func next_line():
	current_line += 1
	show_line()
