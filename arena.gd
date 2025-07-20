extends Node3D
@onready var unit_container: Node3D = $UnitContainer

var power = preload("res://Placement/power_generator.tscn")
var turret = preload("res://gun.tscn")
var bank = preload("res://Placement/bank.tscn")
var artillery = preload("res://artillery.tscn")

func _ready():
	randomize()

func _physics_process(delta):
	while (Global.total_energy-Global.energy_used) < 0:
		var structure_list = unit_container.get_children().duplicate()
		structure_list.reverse()
		for structure in structure_list:
			if structure.on:
				structure.delete()
				break
	



func _on_hud_structure_selected(structure : Structure) -> void:
	$Builder.set_selected_structure(structure)


func _on_builder_structure_placed() -> void:
	$HUD.deselect_structure()

func get_random_enemy_location() -> Vector3:
	return $GridMap.get_random_location(true)

func get_random_friendly_location() -> Vector3:
	# All player units  placed are added to the unit container
	var children = unit_container.get_children()
	# Get a random enemy (if there is any)
	if children.size() > 0:
		var random_child = children[randi() % children.size()]
		return random_child.global_position
	else:
		# pick a random cell on the grid:
		return $GridMap.get_random_location(false)

func get_rotation_to_target(target, source):
	var dir = (target - source).normalized()
	if dir.length() > 0:
		var dir_2d = Vector2(dir.x, dir.z)
		var angle = Vector2(0, 1).angle_to(dir_2d)
		return Vector3(0, -angle, 0)
	else:
		return Vector3.ZERO

func spawn_power():
	var Power = power.instantiate()
	add_child(Power)
	Power.position = get_random_enemy_location()
	Power.on = true
	Power.enemy = true
	Power.start()
func spawn_turret():
	var Turret = turret.instantiate()
	add_child(Turret)
	Turret.position = get_random_enemy_location()
	Turret.rotation = get_rotation_to_target(get_random_friendly_location(), Turret.position)
	Turret.on = true
	Turret.enemy = true
	Turret.start()
func spawn_bank():
	var Bank = bank.instantiate()
	add_child(Bank)
	Bank.position = get_random_enemy_location()
	Bank.on = true
	Bank.enemy = true
	Bank.start()
func spawn_artillery():
	var Artillery = artillery.instantiate()
	var target = get_random_friendly_location()
	add_child(Artillery)
	Artillery.position = get_random_enemy_location()
	Artillery.rotation = get_rotation_to_target(target, Artillery.position)
	Artillery.distance_to_target = Artillery.position.distance_to(target)
	Artillery.on = true
	Artillery.enemy = true
	Artillery.start()



func _on_timer_timeout():
	spawn_artillery()
	spawn_turret()
