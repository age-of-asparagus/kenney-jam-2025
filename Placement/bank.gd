extends Node3D


@export var max_health : int
var health : int
@export var rate : float
var distance_to_target : float
@export var on := false
@export var enemy := false

func start():
	health = max_health
	$SubViewport/ProgressBar.max_value = max_health
	$SubViewport/ProgressBar.value = max_health
	if on:
		if enemy:
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		Global.cash += rate
		if health <= 0:
			queue_free()
