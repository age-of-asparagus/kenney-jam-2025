extends Node3D

const RUBBLE = preload("res://Rubble.tscn")
@onready var timer = $Timer
@export var energy_use : int
@export var max_health : int
var health : int
@export var firerate : float

var Cannonball = preload("res://cannonball.tscn")


@export var on := false
@export var enemy := false

var distance_to_target : float

func _ready():
	health = max_health
	$SubViewport/ProgressBar.max_value = max_health
	$SubViewport/ProgressBar.value = max_health

func start():
	if on:
		if enemy:
			Global.enemy_energy_used += energy_use
			var fill_style = StyleBoxFlat.new()
			fill_style.bg_color = Color.RED
			$SubViewport/ProgressBar.add_theme_stylebox_override("fill", fill_style)
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)
		else:
			Global.energy_used += energy_use
		$Timer.wait_time = firerate
		timer.start()

func turn_off():
	on = false

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			turn_off()
			delete()

func delete():
	if not enemy:
		Global.energy_used -= energy_use
	else:
		Global.enemy_energy_used -= energy_use
	var rubble = RUBBLE.instantiate()
	rubble.global_position = global_position
	rubble.rotate_y(2*PI*randf())
	get_tree().current_scene.add_child(rubble)
	queue_free()

func shoot():
	var Cannonball = Cannonball.instantiate()
	get_tree().current_scene.add_child(Cannonball)
	Cannonball.distance_to_target = distance_to_target
	Cannonball.global_position = $Marker3D.global_position
	Cannonball.rotation = rotation
	if enemy:
		Cannonball.get_node("Area3D").set_collision_layer_value(1,false)
		Cannonball.get_node("Area3D").set_collision_layer_value(2,true)
		Cannonball.get_node("Area3D").set_collision_mask_value(1,true)
		Cannonball.get_node("Area3D").set_collision_mask_value(2,false)
	Cannonball.start()


func _on_timer_timeout():
	if on:
		shoot()
