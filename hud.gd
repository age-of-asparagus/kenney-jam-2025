extends CanvasLayer
@onready var structure_selector: ItemList = $MarginContainer/StructureSelector

func _physics_process(delta):
	
	Global.cash += 10
	
	$MarginContainer/HBoxContainer/Cash.text = "$"+str(Global.cash)
	
	$MarginContainer/HBoxContainer2/Energy_Available.text = str(Global.total_energy-Global.energy_used)

func set_inventory(structures:Array[Structure]) -> void:
	for structure in structures:
		# add them all to the selector widget
		structure_selector.add_item(structure.name, structure.icon)


func _on_structure_selector_item_selected(index: int) -> void:
	pass # Replace with function body.
