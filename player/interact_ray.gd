extends RayCast3D
@onready var ray_prompt: Label = $"../../UI/RayPrompt"

@export var max_interact_distance = 3.0

signal interacting(object)
var interact_object = null

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider().owner
		if collider is Interactable:
			ray_prompt.text = collider.get_prompt()
			
			if Input.is_action_pressed(collider.action_input) and not interact_object:
				interact_object = collider
		
		else:
			ray_prompt.text = ""
	else:
		ray_prompt.text = ""
	
	if interact_object:
		ray_prompt.text = interact_object.get_prompt()
		
		var player_position = owner.global_transform.origin
		var object_position = interact_object.global_transform.origin
		var distance_to_object = player_position.distance_to(object_position)
		
		if distance_to_object > max_interact_distance:
			interact_object.interact(false)
			interact_object = null
			interacting.emit(interact_object)
			return
			
		if Input.is_action_just_released(interact_object.action_input):
			interact_object.interact(false)
			interact_object = null
			interacting.emit(interact_object)
			return
		
		interact_object.interact(true)
		interacting.emit(interact_object)
