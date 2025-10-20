extends Node2D

@onready var name_label = $UI/DialogueBox/NameLabel
@onready var text_label = $UI/DialogueBox/DialogueText
@onready var choices_container = $UI/DialogueBox/ChoicesContainer

const GS_PATH := "/root/GameState"

func GS() -> Node:
	return get_node(GS_PATH)

var lines = [
	{"name":"Greedy Man", "text":"Invest a small amount. Shared prosperity!"},
	{"name":"System", "text":"How do you respond?"}
]

var index := 0

func _ready():
	show_line()

func show_line():
	if index < lines.size():
		var L = lines[index]
		name_label.text = L["name"]
		text_label.text = L["text"]
		clear_choices()

		if L["name"] == "System":
			show_choices([
				"Invest a small test",
				"Debunk calmly and warn others",
                "Feign join then report"
			])
	else:
		get_tree().change_scene_to_file("res://HallOfMirrors.tscn")

func clear_choices():
	for c in choices_container.get_children():
		c.queue_free()

func show_choices(options:Array):
	for opt in options:
		var btn := Button.new()
		btn.text = opt
		btn.pressed.connect(on_choice.bind(opt))
		choices_container.add_child(btn)

func on_choice(choice:String):
	match choice:
		"Invest a small test":
			GS().set("greed", GS().get("greed") + 1)
		"Debunk calmly and warn others":
			GS().set("greed", GS().get("greed") - 1)
			GS().set("trust", GS().get("trust") + 1)
		"Feign join then report":
			GS().set("greed", GS().get("greed") - 1)

	index += 1
	show_line()
