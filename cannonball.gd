extends Node3D

var gravity = 0.0025
var velocity : Vector3
var distance_to_target : float
var frames_till_target : float
@export var speed : float
@export var damage = 5
@export var health = 100

func start():
	frames_till_target = distance_to_target/speed
	velocity = basis.z * speed
	velocity.y = frames_till_target/2 * gravity

func _physics_process(delta):
	velocity.y-= gravity
	frames_till_target -= 1
	if frames_till_target <= 1:
		$Area3D.monitoring = true
	if frames_till_target <= 0:
		queue_free()
	position += velocity


func _on_area_3d_area_entered(area):
	if "on" in area.get_owner():
		if area.get_owner().on:
			area.get_owner().health -= damage
	else:
		area.get_owner().health -= damage
