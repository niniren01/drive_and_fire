extends CharacterBody3D
@onready var head: Node3D = $Head
@onready var area_prompt: Label = $UI/AreaPrompt
@onready var speed: Label = $UI/Speed
@onready var cross_hair: CenterContainer = $UI/CrossHair

var interact_object = null
const SPEED = 6.0
const JUMP_VELOCITY = 6

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("R"):
		get_tree().reload_current_scene()
		
	if event.is_action_pressed("quit"):
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y -= event.relative.x * 0.15
		head.rotation_degrees.x -= event.relative.y * 0.15
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -80, 90)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func set_prompt(prompt_text: String):
	area_prompt.text = prompt_text

func set_speed(speed_text: String):
	speed.text = speed_text


func _on_interact_ray_interacting(object: Variant) -> void:
	interact_object = object
	if interact_object:
		if Input.mouse_mode != Input.MOUSE_MODE_CONFINED:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			cross_hair.visible = false
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			cross_hair.visible = true
