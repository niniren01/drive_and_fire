extends Interactable
@onready var mesh: StaticBody3D = $Mesh

@export var control_object : Node3D
@export var control_type := "steer_wheel_rotation"
var object_center_2d := Vector2.ZERO
var last_mouse_pos := Vector2.ZERO
var inital_rotation := Vector3.ZERO

var max_per_rotate := 10 # 最大每次转动角度（单位：角度）
@export var max_rotation := 80 # 最大旋转角度（单位：角度）

func interact(interacting: bool):
	if interacting:
		# 初始化 上一次鼠标位置
		if last_mouse_pos == Vector2.ZERO:
			last_mouse_pos = get_viewport().get_mouse_position()
		# 初始化 物体中心（投影到2D）
		if object_center_2d == Vector2.ZERO:
			object_center_2d = get_viewport().get_camera_3d().unproject_position(mesh.global_transform.origin)
		inital_rotation = mesh.rotation_degrees
		
	else:
		if last_mouse_pos != Vector2.ZERO:
			last_mouse_pos = Vector2.ZERO
		if object_center_2d != Vector2.ZERO:
			object_center_2d = Vector2.ZERO
	
	interacted = interacting

func _input(event: InputEvent) -> void:
	if interacted:
		# 获取新旧位置向量
		var current_mouse_pos = get_viewport().get_mouse_position()
		var last_vector = last_mouse_pos - object_center_2d
		var current_vector = current_mouse_pos - object_center_2d
		# 记录最后鼠标位置
		last_mouse_pos = current_mouse_pos
		
		# 根据2个向量计算夹角↖↑
		var angle_diff = last_vector.angle_to(current_vector)
		
		# 旋转限制
		angle_diff = rad_to_deg(angle_diff)
		angle_diff = clamp(angle_diff, -max_per_rotate, max_per_rotate)
		var target_rotation_y = inital_rotation.y - angle_diff
		target_rotation_y = clamp(target_rotation_y, -max_rotation, max_rotation)
		
		# 应用旋转
		mesh.rotation_degrees.y = target_rotation_y
		var rotation_rate = mesh.rotation_degrees.y/max_rotation
		if control_object:
			control_object.controled(control_type, rotation_rate)
		
