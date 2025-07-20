extends Node3D

@export var energy_use : int
var distance_to_target : float
@export var max_health : int
var health : int
@export var power_generated = 10
var enemy = false
var on = false

func _ready():
	health = max_health
	$SubViewport/ProgressBar.max_value = max_health
	$SubViewport/ProgressBar.value = max_health

func start():
	if on and not enemy:
		Global.total_energy += power_generated

func turn_off():
	on = false
	Global.energy_used -= energy_use

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			Global.total_energy -= power_generated
			queue_free()
