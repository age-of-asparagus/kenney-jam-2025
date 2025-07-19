extends Node3D

@export var health = 5
@export var power_generated = 10

func _ready():
	Global.total_energy += power_generated

func _physics_process(delta):
	if health <= 0:
		Global.total_energy -= power_generated
		queue_free()
