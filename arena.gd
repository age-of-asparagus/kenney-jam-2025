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
		return $GridMap.get_random_location()

func spawn_power():
	
func spawn_turret():

func spawn_bank():
	
func spawn_artillery():



func _on_timer_timeout():
	spawn()
