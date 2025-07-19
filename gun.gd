extends Node3D

var bullet = preload("res://bullet.tscn")


func shoot():
	var Bullet = bullet.instantiate()
	get_tree().current_scene.add_child(Bullet)

func _on_timer_timeout():
	shoot()
