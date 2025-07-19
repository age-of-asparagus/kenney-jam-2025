extends Node3D

@export var health = 5
@export var power_generated = 10
var on = false

func start():
	if on:
		Global.total_energy += power_generated

func _physics_process(delta):
	if on:
		if health <= 0:
			Global.total_energy -= power_generated
			queue_free()
