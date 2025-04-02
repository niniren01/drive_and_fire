class_name BasePedal
extends Area3D

signal pedal_action(is_active: bool)

@export var action_name : String = ""
@export var action_input : String = ""
var player_in_range := false
@onready var prompt_text = "[" + action_input + "]: " + action_name
static var active_pedals : Array[BasePedal] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if !player_in_range:
		emit_signal("pedal_action", false)

func _input(event: InputEvent) -> void:
	if !player_in_range:
		return
	
	if active_pedals.is_empty() or active_pedals[-1] != self:
		return
	
	if event.is_action_pressed(action_input):
		emit_signal("pedal_action", true)
	elif event.is_action_released(action_input):
		emit_signal("pedal_action", false)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if not self in active_pedals:
			active_pedals.append(self)
		
		player_in_range = true
		body.set_prompt(prompt_text)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		active_pedals.erase(self)
		
		if active_pedals.size() > 0:
			body.set_prompt(active_pedals[-1].prompt_text)
		else:
			body.set_prompt("")
