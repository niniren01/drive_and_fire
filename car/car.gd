extends VehicleBody3D

var max_steer = 0.8
var engine_power = 300
var max_speed := 51.0
# 控制器
@export_category("车量控制器")
@export var accel_pedal : Area3D  # 油门
@export var brake_pedal : Area3D  # 刹车
@onready var player := get_tree().get_first_node_in_group("player")
# 运行时状态
var accel_pressed := false
var brake_pressed := false

func _ready():
	accel_pedal.pedal_action.connect(func(active): accel_pressed = active)
	brake_pedal.pedal_action.connect(func(active): brake_pressed = active)

func _process(delta: float) -> void:
	var current_speed = get_current_speed() * 3.6
	if current_speed >= 0:
		var speed_text = str(int(current_speed)) + "km/h"
		prompt_speed(speed_text)
	
	if accel_pressed:
		if current_speed >= max_speed:
			engine_force = 0
		else:
			engine_force = engine_power
	elif brake_pressed and current_speed > 0.0:
		engine_force = -engine_power
	else:
		engine_force = 0
		if abs(current_speed) < 0.3:
			linear_velocity = Vector3.ZERO

func get_current_speed():
	var forward_dir = -global_basis.z.normalized()
	return linear_velocity.dot(forward_dir)

func prompt_speed(speed_text):
	if player:
		player.set_speed(speed_text)

func controled(control_type : String, amount : float):
	if control_type == "steer_wheel_rotation":
		steering = amount * max_steer
