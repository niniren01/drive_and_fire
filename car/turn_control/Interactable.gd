extends Node3D
class_name Interactable

@export var action_name := ""
@export var action_input := ""

var interacted := false

func get_prompt() -> String:
	var prompt_text := "[" + action_input + "]: " + action_name
	return prompt_text

func interact(interacting: bool):
	interacted = interacting
