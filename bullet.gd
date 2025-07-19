extends Node3D

@export var damage : int
@export var health : int
@export var speed : float

func _physics_process(delta):
	if health <= 0:
		queue_free()
	position += basis.z*speed


func _on_area_3d_area_entered(area):
	area.get_owner().health -= damage
