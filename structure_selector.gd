extends ItemList

var inventory : Array[Structure] = []

func set_inventory(structures:Array[Structure]) -> void:
	inventory = get_structures()
	for structure in inventory:
		# add them all to the selector widget
		add_structure(structure)
		
func add_structure(structure: Structure):
	self.add_item(structure.name, structure.icon)
	
func get_structures():
	var builder = get_tree().current_scene.find_node("Builder")
	return builder.structures 
	
