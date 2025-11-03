extends Node2D

@onready var name_label        = $UI/DialogueBox/NameLabel
@onready var text_label        = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

var lines = [
	{"name":"Conductor", "text":"Tickets, please."},
	{"name":"Conductor", "text":"You carry a choice, not luggage."},
	{"name":"Conductor", "text":"No disturbance."},
	{"name":"Conductor", "text":"Every stop examines the same thing."},
	{"name":"System",     "text":"[Stop 1 — Bread Trial begins]"}
]

var index := 0

func _ready():
	GameState.reset()
	show_line()

func show_line():
	clear_choices()
	if index < lines.size():
		var L = lines[index]
		name_label.text = L["name"]
		text_label.text = L["text"]
	else:
		get_tree().change_scene_to_file("res://BreadTrial.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		index += 1
		show_line()
