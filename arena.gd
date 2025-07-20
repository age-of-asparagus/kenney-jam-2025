extends Node3D
@onready var unit_container: Node3D = $UnitContainer
@onready var enemy_container = $EnemyContainer

var RNG = RandomNumberGenerator.new()

var power = preload("res://Placement/power_generator.tscn")
var turret = preload("res://gun.tscn")
var bank = preload("res://Placement/bank.tscn")
var artillery = preload("res://artillery.tscn")

func _ready():
	RNG.randomize()
	randomize()

func _physics_process(delta):

	while (Global.total_energy-Global.energy_used) < 0:
		var structure_list = unit_container.get_children().duplicate()
		structure_list.reverse()
		for structure in structure_list:
			if structure.on and structure.energy_use > 0:
				structure.delete()
				break
	
	while (Global.enemy_total_energy-Global.enemy_energy_used) < 0:
		var structure_list = enemy_container.get_children().duplicate()
		structure_list.reverse()
		for structure in structure_list:
			if structure.on and structure.energy_use > 0:
				structure.delete()
				break
	



func _on_hud_structure_selected(structure : Structure) -> void:
	$Builder.set_selected_structure(structure)


func _on_builder_structure_placed() -> void:
	$HUD.deselect_structure()

func get_random_enemy_location() -> Vector3:
	return $GridMap.get_random_location(true, true)

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

func initialize_enemy(scene):
	scene.on=true
	scene.enemy=true
	scene.start()
	$GridMap.mark_cell_occupied(scene.position)
	
func spawn_power():
	var Power = power.instantiate()
	add_child(Power)
	Power.position = get_random_enemy_location()
	initialize_enemy(Power)
	
func spawn_turret():
	var Turret = turret.instantiate()
	add_child(Turret)
	Turret.position = get_random_enemy_location()
	Turret.rotation = get_rotation_to_target(get_random_friendly_location(), Turret.position)
	initialize_enemy(Turret)
	
func spawn_bank():
	var Bank = bank.instantiate()
	add_child(Bank)
	Bank.position = get_random_enemy_location()
	initialize_enemy(Bank)
	
func spawn_artillery():
	var Artillery = artillery.instantiate()
	var target = get_random_friendly_location()
	add_child(Artillery)
	Artillery.position = get_random_enemy_location()
	Artillery.rotation = get_rotation_to_target(target, Artillery.position)
	Artillery.distance_to_target = Artillery.position.distance_to(target)
	initialize_enemy(Artillery)

func _on_timer_timeout():
	if (Global.enemy_total_energy - Global.enemy_energy_used) >= 25:
		var Random = RNG.randi_range(1,100)
		if Random < 10:
			spawn_power()
		elif Random <20:
			spawn_bank()
		elif Random <50:
			spawn_turret()
		else:
			spawn_artillery()
	elif (Global.enemy_total_energy - Global.enemy_energy_used) >= 10:
		var Random = RNG.randi_range(1,100)
		if Random <35:
			spawn_power()
		elif Random <55:
			spawn_bank()
		else:
			spawn_turret()
	elif (Global.enemy_total_energy - Global.enemy_energy_used) >= 5:
		var Random = RNG.randi_range(1,100)
		if Random <60:
			spawn_power()
		else:
			spawn_bank()
	else:
		spawn_power()
	$Timer.start(Global.enemy_spawn_rate)
