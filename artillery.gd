extends Node3D

@onready var timer = $Timer

@export var max_health : int
var health : int
@export var firerate : float

#var projectile = preload()


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
