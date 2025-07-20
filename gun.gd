extends Node3D
@onready var timer = $Timer

@export var health : int
@export var firerate : float

var bullet = preload("res://bullet.tscn")
var bullet_position_index = 0
@onready var bullet_position =[
	$left_shooter,
	$right_shooter
]

@export var on := false
@export var enemy := false

func start():
	if on:
		if enemy:
			$Area3D.set_collision_layer_value(1,false)
			$Area3D.set_collision_layer_value(2,true)
		$Timer.wait_time = firerate
		timer.start()

func _physics_process(delta):
	if on:
		if health <= 0:
			queue_free()

func shoot():
	var Bullet = bullet.instantiate()
	get_next_bullet_position()
	Bullet.global_position = bullet_position[bullet_position_index].global_position
	Bullet.rotation = rotation
	if enemy:
		print("hi")
		Bullet.get_node("Area3D").set_collision_layer_value(1,false)
		Bullet.get_node("Area3D").set_collision_layer_value(2,true)
		Bullet.get_node("Area3D").set_collision_mask_value(1,true)
		Bullet.get_node("Area3D").set_collision_mask_value(2,false)
	get_tree().current_scene.add_child(Bullet)


func get_next_bullet_position():
	bullet_position_index += 1
	if bullet_position_index == bullet_position.size():
		bullet_position_index = 0

func _on_timer_timeout():
	if on:
		shoot()
