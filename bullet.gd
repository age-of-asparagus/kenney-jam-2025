extends Node3D

@export var speed = 1

func _physics_process(delta):
	position.x += speed
