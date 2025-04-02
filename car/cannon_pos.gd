extends Node3D

func controled(control_type : String, amount : float):
	if control_type == "rotate_x":
		rotation_degrees.x = amount * 0.1
