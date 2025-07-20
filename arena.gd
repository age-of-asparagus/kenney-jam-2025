extends Node3D
 
func _ready():
	$Gun.start()
	$Gun2.start()

func _on_hud_structure_selected(structure : Structure) -> void:
	$Builder.set_selected_structure(structure)


func _on_builder_structure_placed() -> void:
	$HUD.deselect_structure()
