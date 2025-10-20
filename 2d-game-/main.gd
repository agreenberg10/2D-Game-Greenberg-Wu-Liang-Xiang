extends Node2D

# -----------------------------
# Hidden stats
# -----------------------------
var greed = 0
var charity = 0
var trust = 0

# -----------------------------
# Dialogue data
# -----------------------------
var dialogue = []
var current_line = 0

# -----------------------------
# Node references
# -----------------------------
@onready var name_label = $UI/DialogueBox/NameLabel
@onready var text_label = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

# -----------------------------
# When the scene starts
# -----------------------------
func _ready():
	load_intro()
	show_line()

# -----------------------------
# Example dialogue list
# -----------------------------
func load_intro():
	dialogue = [
		{"name": "Conductor", "text": "Tickets, please. You carry a choice, not luggage."},
		{"name": "Player", "text": "A... choice?"},
		{"name": "Conductor", "text": "Every stop examines the same thing."},
		{"name": "System", "text": "[Stop 1 – Bread Trial begins]"},
		{"name": "Girl", "text": "Would you share your bread?"}
	]

# -----------------------------
# Show each line of dialogue
# -----------------------------
func show_line():
	if current_line < dialogue.size():
		var line = dialogue[current_line]
		name_label.text = line["name"]
		text_label.text = line["text"]
		clear_choices()

		# When this line contains "bread", show choices
		if line["text"].find("bread") != -1:
			show_choices(["Give bread", "Refuse", "Let the girl decide"])
	else:
		text_label.text = "End of scene."

# -----------------------------
# Go to the next line
# -----------------------------
func next_line():
	current_line += 1
	show_line()

# -----------------------------
# Clear previous choice buttons
# -----------------------------
func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()

# -----------------------------
# Display new choice buttons
# -----------------------------
func show_choices(options: Array):
	for opt in options:
		var btn = Button.new()
		btn.text = opt
		btn.connect("pressed", Callable(self, "_on_choice_pressed").bind(opt))
		choices_container.add_child(btn)

# -----------------------------
# Handle choice results
# -----------------------------
func _on_choice_pressed(choice):
	match choice:
		"Give bread":
			charity += 1
		"Refuse":
			greed += 1
		"Let the girl decide":
			charity += 2
			trust += 1
	next_line()

# -----------------------------
# Allow pressing Enter / Space
# to continue dialogue
# -----------------------------
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		next_line()
