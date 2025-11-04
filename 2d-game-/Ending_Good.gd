extends Node2D

@onready var text_label = $UI/DialogueBox/DialogueText

func _ready():
	text_label.text = "Dawn Station — You re-enter reality with courage.\n\nYou saw others as ends, not means.\nYou chose boundaries and trust.\n\n(Press Enter to finish.)"

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().quit()
