#Greenberg Code#
extends TextureRect
class_name DialogueScene
@export var dialogueresource: DialogueResource
@export var background: Texture
@export var nextscene: PackedScene

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_dialogueover)
	DialogueManager.show_dialogue_balloon(dialogueresource)
	texture = background

func _dialogueover(_dialogueresource):
	get_tree().change_scene_to_packed(nextscene)
	print ("Done")
	
