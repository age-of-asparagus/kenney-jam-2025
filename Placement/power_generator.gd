extends Node3D

const RUBBLE = preload("res://Rubble.tscn")
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
	elif enemy:
			var fill_style = StyleBoxFlat.new()
			fill_style.bg_color = Color.RED
			$SubViewport/ProgressBar.add_theme_stylebox_override("fill", fill_style)
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)

func turn_off():
	on = false
	Global.energy_used -= energy_use

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			var rubble = RUBBLE.instantiate()
			rubble.global_position = global_position
			rubble.rotate_y(2*PI*randf())
			get_tree().current_scene.add_child(rubble)
			Global.total_energy -= power_generated
			queue_free()
