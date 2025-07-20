extends Node3D
@onready var unit_container: Node3D = $UnitContainer

var power = preload("res://Placement/power_generator.tscn")
var turret = preload("res://gun.tscn")
var bank = preload("res://Placement/bank.tscn")
var artillery = preload("res://artillery.tscn")

func _ready():
	randomize()
	$Gun.start()
	$Gun2.start()




func _on_hud_structure_selected(structure : Structure) -> void:
	$Builder.set_selected_structure(structure)


func _on_builder_structure_placed() -> void:
	$HUD.deselect_structure()


func get_random_enemy_location() -> Vector3:
	# All player units  placed are added to the unit container
	var children = unit_container.get_children()
	# Get a random enemy (if there is any)
	if children.size() > 0:
		var random_child = children[randi() % children.size()]
		return random_child.global_position
	else:
		# pick a random cell on the grid:
		return $GridMap.get_random_location(true)

func spawn_power():
	var Power = power.instantiate()
	add_child(Power)
	power.position = get_random_enemy_location()
	power.on = true
	power.start()
func spawn_turret():
	var Turret = turret.instantiate()
func spawn_bank():
	var Bank = bank.instantiate()
func spawn_artillery():
	var Artillery = artillery.instantiate()


func _on_timer_timeout():
	spawn_power()
