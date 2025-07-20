extends Node3D
 
func _ready():
	$HUD.set_inventory($Builder.structures)
	$Gun.start()

func _on_hud_structure_selected(structure : Structure) -> void:
	$Builder.set_selected_structure(structure)
