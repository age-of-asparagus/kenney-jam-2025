extends Node3D

@onready var timer = $Timer

@export var max_health : int
var health : int
@export var firerate : float

var Cannonball = preload("res://cannonball.tscn")


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
		$Timer.wait_time = firerate
		timer.start()

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			queue_free()

func shoot():
	var Cannonball = Cannonball.instantiate()
	get_tree().current_scene.add_child(Cannonball)
	Cannonball.global_position = $Marker3D.global_position
	Cannonball.rotation = rotation
	if enemy:
		Cannonball.get_node("Area3D").set_collision_layer_value(1,false)
		Cannonball.get_node("Area3D").set_collision_layer_value(2,true)
		Cannonball.get_node("Area3D").set_collision_mask_value(1,true)
		Cannonball.get_node("Area3D").set_collision_mask_value(2,false)


func _on_timer_timeout():
	if on:
		shoot()
