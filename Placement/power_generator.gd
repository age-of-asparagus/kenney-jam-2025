extends Node3D

var distance_to_target : float
@export var max_health : int
var health : int
@export var power_generated = 10
var on = false

func start():
	health = max_health
	$SubViewport/ProgressBar.max_value = max_health
	$SubViewport/ProgressBar.value = max_health
	if on:
		Global.total_energy += power_generated

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			Global.total_energy -= power_generated
			queue_free()
