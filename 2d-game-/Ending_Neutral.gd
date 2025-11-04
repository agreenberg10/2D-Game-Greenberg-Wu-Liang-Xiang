extends Node2D

@onready var text_label = $UI/DialogueBox/DialogueText

func _ready():
	text_label.text = "Loop Station — An unfinished choice.\n\nYou neither harmed nor helped decisively.\nThe cycle may begin again.\n\n(Press Enter to exit.)"

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().quit()
