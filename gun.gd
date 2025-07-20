extends Node3D
@onready var timer = $Timer
var distance_to_target : float
@export var max_health : int
var health : int
@export var firerate : float

const RUBBLE = preload("res://Rubble.tscn")
var bullet = preload("res://bullet.tscn")
var bullet_position_index = 0
@onready var bullet_position =[
	$left_shooter,
	$right_shooter
]
@export var energy_use : int
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
		$Timer.wait_time = firerate
		timer.start()

func turn_off():
	on = false
	if not enemy:
		Global.energy_used -= energy_use

func _physics_process(delta):
	$SubViewport/ProgressBar.value = health
	if on:
		if health <= 0:
			turn_off()
			delete()

func delete():
	var rubble = RUBBLE.instantiate()
	rubble.global_position = global_position
	rubble.rotate_y(2*PI*randf())
	get_tree().current_scene.add_child(rubble)
	queue_free()

func shoot():
	var Bullet = bullet.instantiate()
	get_next_bullet_position()
	get_tree().current_scene.add_child(Bullet)
	Bullet.global_position = bullet_position[bullet_position_index].global_position
	Bullet.rotation = rotation
	if enemy:
		Bullet.get_node("Area3D").set_collision_layer_value(1,false)
		Bullet.get_node("Area3D").set_collision_layer_value(2,true)
		Bullet.get_node("Area3D").set_collision_mask_value(1,true)
		Bullet.get_node("Area3D").set_collision_mask_value(2,false)



func get_next_bullet_position():
	bullet_position_index += 1
	if bullet_position_index == bullet_position.size():
		bullet_position_index = 0

func _on_timer_timeout():
	if on:
		shoot()
