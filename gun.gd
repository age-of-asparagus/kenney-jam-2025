extends Node3D

@export var health : int
@export var firerate : float

var bullet = preload("res://bullet.tscn")
var bullet_position_index = 0
@onready var bullet_position =[
	$left_shooter,
	$right_shooter
]

var on = false

func _ready():
	if on:
		$Timer.wait_time = firerate

func _physics_process(delta):
	if on:
		if health <= 0:
			queue_free()

func shoot():
	var Bullet = bullet.instantiate()
	get_next_bullet_position()
	Bullet.global_position = bullet_position[bullet_position_index].global_position
	Bullet.rotation = rotation
	get_tree().current_scene.add_child(Bullet)


func get_next_bullet_position():
	bullet_position_index += 1
	if bullet_position_index == bullet_position.size():
		bullet_position_index = 0

func _on_timer_timeout():
	if on:
		shoot()
