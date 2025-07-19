extends Node3D

@export var speed : float

func _physics_process(delta):
	position.z += speed
