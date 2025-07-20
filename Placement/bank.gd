extends Node3D

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
	if on:
		if enemy:
			var fill_style = StyleBoxFlat.new()
			fill_style.bg_color = Color.RED
			$SubViewport/ProgressBar.add_theme_stylebox_override("fill", fill_style)
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)
		else:
			Global.energy_used += energy_use

func turn_off():
	on = false
	Global.energy_used -= energy_use

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		Global.cash += rate
		if health <= 0:
			turn_off()
			queue_free()
