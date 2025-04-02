extends Node3D

func controled(control_type : String, amount : float):
	if control_type == "rotate_y":
		rotation_degrees.y = amount * 0.1
