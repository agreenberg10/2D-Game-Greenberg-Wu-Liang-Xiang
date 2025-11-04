extends Node2D

@onready var name_label        = $UI/DialogueBox/NameLabel
@onready var text_label        = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

var questions = [
	"Whom did you give to? Why?",
	"What did you refuse? Why?",
    "Whom did you trust? Why were they worthy?"
]

var idx: int = 0

func _ready():
	name_label.text = "Conductor"
	var why: String = GameState.why_line
	if why == "":
		why = "(silent)"
	text_label.text = "Final judgment. Your reason: " + why
	next_q()

func next_q():
	clear_choices()
	if idx < questions.size():
		text_label.text = questions[idx]
		var answer := Button.new()
		answer.text = "Answer"
		answer.pressed.connect(func():
			idx += 1
			next_q()
		)
		choices_container.add_child(answer)
	else:
		decide()

func decide():
	if GameState.greed <= -1 and GameState.charity >= 2 and GameState.trust >= 1:
		get_tree().change_scene_to_file("res://Ending_Good.tscn")
	elif GameState.greed >= 2:
		get_tree().change_scene_to_file("res://Ending_Evil.tscn")
	else:
		get_tree().change_scene_to_file("res://Ending_Neutral.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()
