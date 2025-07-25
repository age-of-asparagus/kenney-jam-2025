extends Node3D

const RUBBLE = preload("res://Rubble.tscn")
@export var energy_use : int
@export var max_health : int
var health : int
@export var rate : float
var distance_to_target : float
@export var on := false
@export var enemy := false

func _ready():
	health = max_health
	$SubViewport/ProgressBar.max_value = max_health
	$SubViewport/ProgressBar.value = max_health

func start():
	$AudioStreamPlayer.play()
	if on:
		if enemy:
			Global.enemy_energy_used += energy_use
			Global.enemy_spawn_rate *= 0.9
			var fill_style = StyleBoxFlat.new()
			fill_style.bg_color = Color.RED
			$SubViewport/ProgressBar.add_theme_stylebox_override("fill", fill_style)
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)
		else:
			Global.energy_used += energy_use

func turn_off():
	on = false


func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on and not enemy:
		Global.cash += rate
	if health <= 0:
		turn_off()
		delete()


func delete():
	if not enemy:
		Global.energy_used -= energy_use
	else:
		Global.enemy_energy_used -= energy_use
		Global.enemy_spawn_rate /= 0.9
	var rubble = RUBBLE.instantiate()
	rubble.global_position = global_position
	rubble.rotate_y(2*PI*randf())
	get_tree().current_scene.add_child(rubble)
	queue_free()
