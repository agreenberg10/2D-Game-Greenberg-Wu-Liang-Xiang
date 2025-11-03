extends Node2D

@onready var text_label = $UI/DialogueBox/DialogueText

func _ready():
	text_label.text = "Abyss Station — You treated others as tools.\n\nGreed became your compass.\nCompassion and trust withered.\n\n(Press Enter to exit.)"

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().quit()
