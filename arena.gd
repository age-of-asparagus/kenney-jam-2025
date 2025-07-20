extends Node3D
 
func _ready():
	$Gun.on = true
	$Gun.enemy = true
	$HUD.set_inventory($Builder.structures)
