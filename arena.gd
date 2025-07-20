extends Node3D
 
func _ready():
	$HUD.set_inventory($Builder.structures)
	$Gun.start()
